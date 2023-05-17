data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.cluster.outputs.name
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

resource "helm_release" "nginx" {
  depends_on = [
    kubernetes_namespace.test,
  ]
  name       = "bitnami"
  chart      = "apache"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = "test"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  values = [
    <<-EOT
    ingress:
      enabled: true
      annotations:
        kubernetes.io/ingress.class: "alb"
        alb.ingress.kubernetes.io/scheme: "internet-facing"
        alb.ingress.kubernetes.io/target-type: "ip"
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}, {"HTTP": 8080}, {"HTTPS": 8443}]'
        alb.ingress.kubernetes.io/manage-backend-security-group-rules: "true"
      hostname: test.familleducret.net
      path: /
    EOT
  ]
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

# output "nginx_service" {
#   value = data.kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].hostname
# }
