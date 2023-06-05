resource "aws_route53_record" "lb" {
  name = var.route53_uri
  type = "CNAME"
  ttl  = "300"
  records = [
    aws_lb.this.dns_name
  ]
  zone_id = data.aws_route53_zone.this.id
}
