locals {
  tg_lb_protocol = "HTTPS"
}

resource "aws_lb" "this" {
  depends_on                 = [aws_acm_certificate_validation.this]
  name                       = var.lb_name
  internal                   = false
  load_balancer_type         = var.lb_type
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = false
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.lb_tg_port
  protocol          = local.tg_lb_protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.this.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  name_prefix = var.lb_tg_prefix_name
  port        = var.lb_tg_port
  protocol    = local.tg_lb_protocol
  vpc_id      = var.vpc_id
  health_check {
    path     = var.lb_tg_health_check_path
    protocol = var.lb_tg_health_check_protocol
  }
}
