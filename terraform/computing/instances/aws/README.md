# AWS Computing Instances module

This module is responsible of instances deployment in AWS.
By default it will deploy spot instances, this can be tuned since the ASG uses mixed instances policy.
Use the following vars to do so:

* `on_demand_allocation_strategy`
* `on_demand_base_capacity`
* `spot_allocation_strategy`
* `spot_instance_pools`
* `spot_max_price`

## How to


### Test

> ⚠️ You need to have python3 installed on you laptop to run the tests.

In `terraform/computing/instances/tests` there is a `makefile` that can be used to test the module.

* `make plan` will dry run
* `make all` will apply and test the created resources

The `make all` test is used by the CI and should success for a PR to be considered to be mergeable.


> 🔑  In order to allow Terraform to run agains AWS you also need to provide the following env vars:
> * `export AWS_REGION=<REGION>`
> * `export AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>`
> * `export AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID>`

### Deploy

Deploy the network using the [network module](../../../network/aws/README.md)
Then you can call this module

```terraform
module "instances" {
  source = "github.com/github.com/DucretJe/std-deploy//terraform/computing/instances/aws"

  ami_owner            = ""
  asg_desired_capacity = 1
  asg_max_size         = 1
  asg_min_size         = 1
  asg_tags = {
    terraform = "true"
    test      = "true"
  }
  asg_vpc_zone_identifier                                        = data.terraform_remote_state.network.outputs.subnet_ids
  launch_template_block_device_mappings_device_name              = "/dev/xvda"
  launch_template_block_device_mappings_ebs_volume_size          = 10
  launch_template_instance_type                                  = "t2.micro"
  launch_template_name_prefix                                    = "ltmplt"
  launch_template_network_interfaces_associate_public_ip_address = true
  security_groups = [
    data.terraform_remote_state.network.outputs.sg_id
  ]
  launch_template_tags = {
    terraform = "true"
    test      = "true"
    name      = "test"
  }
  ami_filters = {
    name = ["bitnami-nginx-1.23.3-21-r20-linux-debian-11-x86_64-hvm-ebs-nami-*"]
  }
  spot_max_price = "0.004"
  ssh_keys       = [data.http.ssh_keys.body]
  subnets        = data.terraform_remote_state.network.outputs.subnet_ids
  vpc_id         = data.terraform_remote_state.network.outputs.vpc_id
}
```
