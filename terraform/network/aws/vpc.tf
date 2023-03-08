resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = var.vpc_tags
}

resource "aws_flow_log" "vpc_logs" {
  iam_role_arn    = aws_iam_role.vpc_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  tags = var.vpc_tags
}

resource "aws_cloudwatch_log_group" "vpc_logs" {
  name = "vpc-logs"

  tags = var.vpc_tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_logs" {
  name               = "vpc-logs"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.vpc_tags
}

data "aws_iam_policy_document" "vpc_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vpc_logs" {
  name   = "vpc-logs"
  role   = aws_iam_role.vpc_logs.id
  policy = data.aws_iam_policy_document.vpc_logs.json

  tags = var.vpc_tags
}
