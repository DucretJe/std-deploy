output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the log group"
  value       = aws_cloudwatch_log_group.cloudwatch_log_group.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource"
  value       = aws_cloudwatch_log_group.cloudwatch_log_group.tags_all
}
