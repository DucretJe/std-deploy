# AWS Computing EKS module

This module is responsible of EKS cluster & worker nodes deployment in AWS.
It will deploy it in a public subnet.

TODO: Add choice to deploy in private subnets.

## How to

### Test

> ⚠️ You need to have python3 installed on you laptop to run the tests.

In `terraform/computing/eks/tests` there is a `makefile` that can be used to test the module.

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
module "cluster" {
  source = "../../aws/"

  eks_cluster_name        = data.terraform_remote_state.network.outputs.eks_cluster_name
  eks_cluster_subnets_ids = data.terraform_remote_state.network.outputs.public_subnet_ids

  eks_group_nodes_tags = {
    "kubernetes.io/cluster/${data.terraform_remote_state.network.outputs.eks_cluster_name}"     = "owned"
    "k8s.io/cluster-autoscaler/${data.terraform_remote_state.network.outputs.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                                                         = "true"
  }

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}
```
