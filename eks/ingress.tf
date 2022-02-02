resource "helm_release" "ingress_nginx_controller" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.0.16"
  namespace  = "ingress-nginx"
  atomic     = true
  timeout    = 900

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
  #  set {
  #    name  = "controller.metrics.service.annotations.prometheus\\.io/scrape"
  #    value = "true"
  #  }
  #  set {
  #    name  = "controller.metrics.service.annotations.prometheus\\.io/port"
  #    value = "10254"
  #  }
  set {
    name  = "controller.service.targetPorts.http"
    value = "http"
  }
  set {
    name  = "controller.service.targetPorts.https"
    value = "http"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "https"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.cluster_domain.id
  }
  # https://aws.amazon.com/ko/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  depends_on = [
    kubernetes_namespace.ingress_nginx,
    aws_acm_certificate.cluster_domain
  ]
}
