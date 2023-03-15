output "aws_launch_template_id" {
  description = "id of the launch configuration"
  value       = aws_launch_template.this.id
}

output "aws_autoscaling_group_id" {
  description = "id of the autoscaling group"
  value       = aws_autoscaling_group.this.id
}

output "aws_load_balancer_dns_name" {
  description = "dns name of the load balancer"
  value       = aws_lb.this.dns_name
}
