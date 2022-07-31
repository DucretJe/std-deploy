resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = var.cloudwatch_log_group_name
  name_prefix       = var.cloudwatch_log_group_name_prefix
  retention_in_days = var.cloudwatch_log_group_retention_in_day
  kms_key_id        = var.cloudwatch_log_group_kms_id
  tags              = var.cloudwatch_log_group_tags
}
