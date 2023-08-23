provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.aws_eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.aws_eks_cluster_kubeconfig_ca_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml"
  repository_cache       = "${path.module}/.helm"
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.aws_eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.aws_eks_cluster_kubeconfig_ca_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}
