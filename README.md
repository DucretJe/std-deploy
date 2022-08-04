# Deployments toolbox

* We will use [Terraform Cloud](https://app.terraform.io)

## AWS

[Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### Authentication

* In AWS console
  * Go to IAM
    * Users
      * Create a user for TF with correct rights
      * Create a key for this user
* Define the following `environment variables`:
  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `AWS_REGION`

> Closest region from CH is `eu-central-1`

### Modules

* [AWS Cloudwatch Group](./terraform/modules/aws_cloudwatch_group/README.md)
* [AWS IAM Role](./terraform/modules/aws_iam_role/README.md)
* [AWS VPC](./terraform/modules/aws_vpc/README.md)

