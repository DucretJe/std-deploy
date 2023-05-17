locals {
  externaldns_provider = {
    name = "cloudflare"
    config = {
      "cloudflare.apiToken" = var.cloudflare_apitoken
      "cloudflare.zone"     = "familleducret.net"
    }
  }
}

module "cluster" {
  source = "../../aws/"

  eks_cluster_name                = data.terraform_remote_state.network.outputs.eks_cluster_name
  eks_cluster_public_subnets_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
  eks_cluster_private_subnets_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  eks_group_nodes_tags = {
    "kubernetes.io/cluster/${data.terraform_remote_state.network.outputs.eks_cluster_name}"     = "owned"
    "k8s.io/cluster-autoscaler/${data.terraform_remote_state.network.outputs.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                                                         = "true"
  }

  eks_private_access = true
  eks_public_access  = true

  externaldns_provider_settings = {
    provider              = "cloudflare"
    "cloudflare.apiToken" = var.cloudflare_apitoken
    "cloudflare.zone"     = "familleducret.net"
  }

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../01-network/terraform.tfstate"
  }
}

output "aws_eks_cluster_endpoint" {
  value = module.cluster.endpoint
}

output "aws_eks_cluster_kubeconfig_ca_data" {
  value     = module.cluster.aws_eks_cluster_kubeconfig_ca_data
  sensitive = true
}

output "name" {
  value = module.cluster.name
}
