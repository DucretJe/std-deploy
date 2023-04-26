# AWS Network module

This module is responsible of the network deployment in AWS.
By default it creates an internet gateway and use it in the created VPC this can be disabled using the variable `internet_gateway = false`

## How to


### Test

> ⚠️ You need to have python3 installed on you laptop to run the tests.

In `terraform/network/tests` there is a `makefile` that can be used to test the module.

* `make plan` will dry run
* `make all` will apply and test the created resources

The `make all` test is used by the CI and should success for a PR to be considered to be mergeable.


> 🔑  In order to allow Terraform to run agains AWS you also need to provide the following env vars:
> * `export AWS_REGION=<REGION>`
> * `export AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>`
> * `export AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID>`

### Deploy

```terraform
resource "random_id" "id" {
  byte_length = 8
}

module "network" {
  source = "../../aws/"

  sg_description = "Security group for the VPC"
  sg_egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  sg_ingress_rules = [
    {
      description = "Allow HTTPS inbound traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  sg_name = "sg"

  vpc_cidr      = "10.0.0.0/16"
  vpc_logs_name = "vpc-logs-${random_id.id.hex}"
}
```
