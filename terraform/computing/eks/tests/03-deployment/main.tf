locals {
  hosted_zone = "test.familleducret.net"
  service_url = "autotest.${local.hosted_zone}"
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.cluster.outputs.name
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

resource "helm_release" "nginx" {
  depends_on = [
    kubernetes_namespace.test,
  ]
  name       = "bitnami"
  chart      = "apache"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = "test"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  values = [
    <<-EOT
    ingress:
      enabled: true
      annotations:
        kubernetes.io/ingress.class: "alb"
        alb.ingress.kubernetes.io/scheme: "internet-facing"
        alb.ingress.kubernetes.io/target-type: "ip"
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
        alb.ingress.kubernetes.io/ssl-redirect: '443'
        alb.ingress.kubernetes.io/manage-backend-security-group-rules: "true"
      hostname: ${local.service_url}
      path: '/*'
    EOT
  ]
}

resource "aws_acm_certificate" "this" {
  domain_name       = local.service_url
  validation_method = "DNS"
}

data "aws_route53_zone" "this" {
  name         = local.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}


data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../02-cluster/terraform.tfstate"
  }
}

data "kubernetes_service" "nginx" {
  depends_on = [helm_release.nginx]
  metadata {
    name      = helm_release.nginx.name
    namespace = helm_release.nginx.namespace
  }
}

output "url" {
  value = "https://${local.service_url}"
}
