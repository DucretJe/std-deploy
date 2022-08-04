resource "aws_iam_role" "iam_role" {
  name        = var.iam_role_name_prefix == null ? var.iam_role_name : null
  name_prefix = var.iam_role_name == null ? var.iam_role_name_prefix : null
  description = var.iam_role_description

  assume_role_policy = var.iam_role_assume_role_policy

  force_detach_policies = var.iam_role_force_detach_policies

  dynamic "inline_policy" {
    for_each = var.iam_role_policy_inline_policy_name == null ? [{ name = var.iam_role_policy_inline_policy_name, policy = var.iam_role_policy_inline_policy_policy }] : []
    content {
      name   = inline_policy.value["name"]
      policy = inline_policy.value["policy"]
    }
  }
  managed_policy_arns = var.iam_role_managed_policy_arns

  max_session_duration = var.iam_role_max_session_duration
  path                 = var.iam_role_path
  permissions_boundary = var.iam_role_permissions_boundary
  tags                 = var.iam_role_tags
}

resource "aws_iam_role_policy" "iam_role_policy" {
  count       = var.iam_role_policy_inline_policy_name == null ? 0 : 1
  name        = var.iam_role_policy_name_prefix == null ? var.iam_role_policy_name : null
  name_prefix = var.iam_role_policy_name == null ? var.iam_role_policy_name_prefix : null
  role        = aws_iam_role.iam_role.id

  policy = var.iam_role_policy_policy
}
