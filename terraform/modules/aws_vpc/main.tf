locals {
  account_arn     = data.aws_caller_identity.current.arn
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_vpc_ipam" "vpc_ipam" {
  operating_regions {
    region_name = data.aws_region.current.name
  }

  description = var.vpc_ipam_description
  tags        = var.vpc_ipam_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_vpc_ipam_pool" "vpc_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.vpc_ipam.private_default_scope_id
  locale         = data.aws_region.current.name

  allocation_default_netmask_length = var.vpc_ipam_pool_allocation_default_netmask_length
  allocation_max_netmask_length     = var.vpc_ipam_pool_allocation_max_netmask_length
  allocation_min_netmask_length     = var.vpc_ipam_pool_allocation_min_netmask_length

  description = var.vpc_ipam_pool_description
  tags        = var.vpc_ipam_pool_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_vpc_ipam_pool_cidr" "vpc_ipam_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.vpc_ipam_pool.id
  cidr         = var.vpc_ipam_pool_cidr_cidr

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_vpc" "vpc" {
  ipv4_ipam_pool_id              = aws_vpc_ipam_pool.vpc_ipam_pool.id
  ipv4_netmask_length            = var.vpc_ipv4_netmask_length
  enable_dns_support             = var.vpc_enable_dns_support
  enable_dns_hostnames           = var.vpc_enable_dns_hostnames
  enable_classiclink             = var.vpc_enable_classiclink
  enable_classiclink_dns_support = var.vpc_enable_classiclink_dns_support

  tags = var.vpc_tags

  depends_on = [
    aws_vpc_ipam_pool_cidr.vpc_ipam_pool_cidr
  ]

  lifecycle {
    prevent_destroy = false
  }
}

## Security
### Security Group

resource "aws_default_security_group" "default_security_group" {
  # Create a Default Security that refuse all IN and OUT connections
  vpc_id = aws_vpc.vpc.id

  tags = var.default_security_group_tags
}

### Logging

module "cloudwatch_group" {
  source = "../aws_cloudwatch_group/"
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "test"
  retention_in_days = 90
  # kms_key_id = aws_kms_key.a.key_id
}

module "iam_role_log" {
  source = "../aws_iam_role"

  iam_role_name = "vpc-flow-logger"
  iam_role_description = "Role allowed to create log group and pull in it"
  iam_role_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  iam_role_policy_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "iam_role" {
  name        = "test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name        = "test"
  role        = aws_iam_role.iam_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}


resource "aws_flow_log" "flow_log" {
  # Ensure AWS VPC Flow logs are enabled
  iam_role_arn    = module.iam_role_log.iam_role_arn
  log_destination = module.cloudwatch_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_kms_key" "a" {
  description             = "hu?"
  deletion_window_in_days = 7
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        sid       = "Enable IAM User Permissions"
        effect    = "Allow"
        actions   = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        resources = ["*"]

        principals = {
          type        = "AWS"
          identifiers = ["${local.account_arn}"]
        }
      }
    ]
  })
}

