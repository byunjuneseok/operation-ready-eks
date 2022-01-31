resource "helm_release" "ingress_nginx_controller" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.16"
  namespace  = "ingress"
  atomic     = true
  timeout    = 900

  values = [
    yamlencode({
      "controller.metrics.enabled": true
    })
  ]

  depends_on = [kubernetes_namespace.ingress]
}
