resource "helm_release" "ingress_nginx_controller" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.0.16"
  namespace  = "ingress-nginx"
  atomic     = true
  timeout    = 900

  # https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
  set {
    name  = "controller.ingressClassResource.name"
    value = "ingress-nginx"
  }
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
  set {
    name  = "controller.service.targetPorts.http"
    value = "80"
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
    value = "443"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.cluster_domain.id
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = "3600"
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
