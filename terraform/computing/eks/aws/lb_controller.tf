data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

data "template_file" "iam_policy_doc" {
  template = data.http.iam_policy.response_body
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "iam_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = data.template_file.iam_policy_doc.rendered
}

resource "aws_iam_role" "alb_iam_role" {
  name               = "AWSLoadBalancerControllerIAMRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${aws_iam_openid_connect_provider.cluster.url}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_iam_openid_connect_provider.cluster.url}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "iam_policy_attachment" {
  role       = aws_iam_role.alb_iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "kubernetes_service_account" "alb" {
  provider = kubernetes

  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_iam_role.arn
    }
  }

  automount_service_account_token = true
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.this.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb.metadata[0].name
  }

  depends_on = [
    kubernetes_service_account.alb
  ]
}
