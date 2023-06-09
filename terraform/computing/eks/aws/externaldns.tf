resource "kubernetes_service_account" "externaldns" {
  automount_service_account_token = true
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.externaldns.arn
    }
  }
}

resource "kubernetes_secret" "externaldns_secret" {
  type = "kubernetes.io/service-account-token"
  metadata {
    name      = "externaldns-token"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.externaldns.metadata.0.name
    }
  }
  depends_on = [kubernetes_service_account.externaldns]
}



resource "helm_release" "externaldns" {
  depends_on = [
    kubernetes_service_account.externaldns,
  ]
  name       = "bitnami"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = "kube-system"

  dynamic "set_sensitive" {
    for_each = var.externaldns_provider_settings
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }

  set {
    name  = "sources[0]"
    value = "service"
  }

  set {
    name  = "sources[1]"
    value = "ingress"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.externaldns.metadata[0].name
  }

  # Because we want to use IRSA (EKS OIDC provider), we need to disable the default service account
  set {
    name  = "podSecurityContext.fsGroup"
    value = "65534"
  }

  # Because we want to use IRSA (EKS OIDC provider), we need to disable the default service account
  set {
    name  = "podSecurityContext.runAsUser"
    value = "0"
  }
}

data "aws_iam_policy_document" "oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.cluster.url}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }
  }
}

resource "aws_iam_role" "externaldns" {
  name               = "externaldns"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}


resource "aws_iam_role_policy_attachment" "externaldns" {
  role       = aws_iam_role.externaldns.name
  policy_arn = aws_iam_policy.externaldns.arn
}

resource "aws_iam_policy" "externaldns" {
  name = "externaldns"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["route53:ChangeResourceRecordSets"]
        Resource = ["arn:aws:route53:::hostedzone/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["route53:ListHostedZones", "route53:ListResourceRecordSets"]
        Resource = ["*"]
      },
    ]
  })
}



resource "kubernetes_cluster_role_binding" "externaldns" {
  metadata {
    name = "externaldns"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "aws-iam-authenticator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.externaldns.metadata[0].name
    namespace = "kube-system"
  }
}


