resource "aws_kms_key" "kms_key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days

  customer_master_key_spec = var.kms_key_customer_master_key_spec
  key_usage = var.kms_key_key_usage
  policy = var.kms_key_policy
  bypass_policy_lockout_safety_check = var.kms_key_bypass_policy_lockout_safety_check
  is_enabled = var.kms_key_is_enabled
  enable_key_rotation = var.kms_key_enable_key_rotation
  multi_region = var.kms_key_multi_region
  tags = var.kms_key_tags
}
