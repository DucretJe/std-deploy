# AWS VPC

This module deploys a [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) using [VPC IPAM](https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html).
This module only supports IPv4.

## Documentation

* [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group)
* [aws_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log)
* [aws_vpc_ipam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam)
* [aws_vpc_ipam_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool)
* [aws_vpc_ipam_pool_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr)
* [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)
* [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

## How to

By default, this module will deploy a VPC IPAM with a CIDR pool of "172.16.0.0/16" containing a VPC using a /16 netmask. It will activate the log on all the traffic in the VPC using [CloudWatch Log Group](../aws_cloudwatch_group/README.md) and create a default security group that deny all the traffic.
You can customize it specifiying the following variables:

* Default Security Group:
  * Tags: `default_security_group_tags`
* VPC IPAM:
  * Description: `vpc_ipam_description`
  * Tags: `vpc_ipam_tags`
* VPC IPAM Pool:
  * Default mask length: `vpc_ipam_pool_allocation_default_netmask_length`
  * Max mask length: `vpc_ipam_pool_allocation_max_netmask_length`
  * Min mask length: `vpc_ipam_pool_allocation_min_netmask_length`
  * Description : `vpc_ipam_pool_description`
  * Tags: `vpc_ipam_pool_tags`
* VPC IPAM Pool CIDR:
  * CIRD: `vpc_ipam_pool_cidr_cidr`
* VPC:
  * Netmask length: `vpc_ipv4_netmask_length`
  * Enable DNS support : `vpc_enable_dns_support`
  * Enable DNS hostnames: `vpc_enable_dns_hostnames`
  * Enable Classic Link: `vpc_enable_classiclink`
  * Enable Classic Link DNS support : `vpc_enable_classiclink_dns_support`
  * Tags: `vpc_tags`
