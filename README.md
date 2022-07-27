# Deployments toolbox

* We will use [Terraform Cloud](https://app.terraform.io)

## AWS

[Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### Authentication

* In AWS console
  * Go to IAM
    * Access Key
    * Create an Access Key
* Define the following `environment variables`:
  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `AWS_REGION`

> Closest region from CH is `eu-central-1`
