output "iam_role_arn" {
  value = aws_iam_role.iam_role.arn
}

output "iam_role_create_date" {
  value = aws_iam_role.iam_role.create_date
}

output "iam_role_id" {
  value = aws_iam_role.iam_role.id
}

output "iam_role_name" {
  value = aws_iam_role.iam_role.name
}

output "iam_role_tags_all" {
  value = aws_iam_role.iam_role.tags_all
}

output "iam_role_unique_id" {
  value = aws_iam_role.iam_role.unique_id
}

output "iam_role_policy_id" {
  value = [aws_iam_role_policy.iam_role_policy.*.id]
}

output "iam_role_policy_name" {
  value = [aws_iam_role_policy.iam_role_policy.*.name]
}

output "iam_role_policy_policy" {
  value = [aws_iam_role_policy.iam_role_policy.*.policy]
}

output "iam_role_policy_role" {
  value = [aws_iam_role_policy.iam_role_policy.*.role]
}
