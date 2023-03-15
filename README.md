# Deployments toolbox

[![🔬 Tests](https://github.com/DucretJe/std-deploy/actions/workflows/terraform.yaml/badge.svg)](https://github.com/DucretJe/std-deploy/actions/workflows/terraform.yaml)
[![✨ Super-Linter](https://github.com/DucretJe/std-deploy/actions/workflows/linter.yaml/badge.svg)](https://github.com/DucretJe/std-deploy/actions/workflows/linter.yaml)
[![💫 Checkov - Terraform](https://github.com/DucretJe/std-deploy/actions/workflows/checkov.yaml/badge.svg)](https://github.com/DucretJe/std-deploy/actions/workflows/checkov.yaml)

## AWS

![AWS Banner](https://cdn3.invitereferrals.com/blog/wp-content/uploads/2013/08/05055035/aws-banner-invitereferrals-min-1281x470.jpg)

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

### Modules

* [Network](./terraform/network/aws/README.md)
* Computing
  * [Instances](./terraform/computing/instances/aws/README.md)
