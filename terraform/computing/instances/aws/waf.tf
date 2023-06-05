resource "aws_wafregional_web_acl_association" "this" {
  resource_arn = aws_lb.this.arn
  web_acl_id   = aws_wafregional_web_acl.this.id
}

# Minimalistic WAF: TODO modularise rules
resource "aws_wafregional_web_acl" "this" {
  name        = var.waf_name
  metric_name = var.waf_name

  default_action {
    type = "ALLOW"
  }
}
