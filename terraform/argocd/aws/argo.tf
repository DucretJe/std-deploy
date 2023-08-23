resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [
    kubernetes_namespace.argocd,
  ]
  name       = "argo"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

data "kubernetes_service" "argocd" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "${helm_release.argocd.name}-${helm_release.argocd.namespace}-server"
    namespace = helm_release.argocd.namespace
  }
}

output "argocd_url" {
  value = data.kubernetes_service.argocd
}
