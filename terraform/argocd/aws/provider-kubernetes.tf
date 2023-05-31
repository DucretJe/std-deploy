provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = var.cluster_token
}

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }