# AWS VPC

This module deploys a [CloudWatch Group](https://aws.amazon.com/fr/cloudwatch/)

## Documentation

* [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)

## How to

By default this module will deploy a CloudWatch group with default name and no prefix nor KMS key ID for encryption. The retention policy is defaulted to 90 days
You can customize it specifiying the following variables:

* Cloudwatch Log group:
  * Name: `cloudwatch_log_group_name`
  * Name prefix: `cloudwatch_log_group_name_prefix`
  * Retention in days: `cloudwatch_log_group_retention_in_day`
  * KMS Key ID: `cloudwatch_log_group_kms_id`
  * Tags: `cloudwatch_log_group_tags`
