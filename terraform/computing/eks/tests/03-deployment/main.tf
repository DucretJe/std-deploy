data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.cluster.outputs.name
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "test"
  }
}

resource "helm_release" "nginx" {
  depends_on = [
    kubernetes_namespace.example,
  ]
  name       = "apache"
  chart      = "apache"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = "test"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}


data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../02-cluster/terraform.tfstate"
  }
}

data "kubernetes_service" "nginx" {
  depends_on = [helm_release.nginx]
  metadata {
    name      = helm_release.nginx.name
    namespace = helm_release.nginx.namespace
  }
}

output "nginx_service" {
  value = data.kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].hostname
}
