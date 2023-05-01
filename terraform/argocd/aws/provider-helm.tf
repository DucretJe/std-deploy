provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml"
  repository_cache       = "${path.module}/.helm"
  #   kubernetes {
  #     host                   = var.cluster_endpoint
  #     cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  #     token                  = var.cluster_token
  #   }
  kubernetes {
    config_path = "~/.kube/config"
  }
}
