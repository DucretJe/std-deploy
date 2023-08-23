data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.cluster.outputs.name
}


module "argocd" {
  source                 = "../../aws/"
  cluster_endpoint       = data.terraform_remote_state.cluster.outputs.aws_eks_cluster_endpoint
  cluster_token          = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.aws_eks_cluster_kubeconfig_ca_data
  cloudflare_api_token   = var.cloudflare_api_token
  cloudflare_account_id  = var.cloudflare_account_id
  cloudflare_zone        = "familleducret.net"
}

data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../02-cluster/terraform.tfstate"
  }
}
