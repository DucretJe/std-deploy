resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  tags = var.lb_tags
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.lb_tg_port
  protocol          = var.lb_tg_protocol

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  name_prefix = var.lb_tg_prefix_name
  port        = var.lb_tg_port
  protocol    = var.lb_tg_protocol
  vpc_id      = var.vpc_id
  health_check {
    path     = var.lb_tg_health_check_path
    protocol = var.lb_tg_health_check_protocol
  }
}
