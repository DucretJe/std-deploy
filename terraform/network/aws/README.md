# AWS Network module

This module is responsible of the network deployment in AWS

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
module "network" {
  source = "github.com/github.com/DucretJe/std-deploy//terraform/network/aws"

  vpc_cidr = "10.0.0.0/16"
  vpc_tags = {
    terraform = "true"
    environment = "dev"
  }
}
```