resource "kubernetes_namespace" "externaldns" {
  metadata {
    name = "externaldns"
  }
}

resource "helm_release" "externaldns" {
  depends_on = [
    kubernetes_namespace.externaldns,
  ]
  name       = "bitnami"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = kubernetes_namespace.externaldns.metadata[0].name

  dynamic "set_sensitive" {
    for_each = var.externaldns_provider_settings
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }

  set {
    name  = "sources[0]"
    value = "service"
  }

  set {
    name  = "sources[1]"
    value = "ingress"
  }
}
