resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

# stolen from https://github.com/aws-samples/terraform-eks-code/blob/ca1fb1aec24d89b12057fc9d4df9a0e1def7abef/cluster/aws_iam_openid_connect_provider.tf
data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-node",
        "system:serviceaccount:kube-system:externaldns",
      ]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster" {
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
  name               = format("irsa-%s-aws-node", aws_eks_cluster.this.name)
}

resource "aws_eks_identity_provider_config" "demo" {
  cluster_name = var.eks_cluster_name
  oidc {
    client_id                     = substr(aws_eks_cluster.this.identity.0.oidc.0.issuer, -32, -1)
    identity_provider_config_name = "cluster"
    issuer_url                    = "https://${aws_iam_openid_connect_provider.cluster.url}"
  }
}
