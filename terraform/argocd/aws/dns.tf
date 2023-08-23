
data "cloudflare_zone" "this" {
  name = var.cloudflare_zone
}

resource "cloudflare_record" "argocd" {
  depends_on = [
    helm_release.argocd,
    data.kubernetes_service.argocd,
  ]
  zone_id = data.cloudflare_zone.this.id
  name    = "argocd.tests.${var.cloudflare_zone}"
  value   = data.kubernetes_service.argocd.status[0].load_balancer[0].ingress[0].hostname
  type    = "CNAME"
  ttl     = 60
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "argocd.tests.${var.cloudflare_zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "cert_validation" {
  zone_id = data.cloudflare_zone.this.id
  name    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, 0)
  type    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, 0)
  value   = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, 0)
  ttl     = 60
  proxied = false
}


resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [cloudflare_record.cert_validation.hostname]
}
