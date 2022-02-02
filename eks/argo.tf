resource "helm_release" "argo_cd" {
  chart      = "argo-cd"
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "3.33.1"
  namespace  = "argo-cd"
  atomic     = true
  timeout    = 900

  #  https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd
  set {
    name  = "server.config.url"
    value = "http://argo.${var.cluster_domain_name}"
  }
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "ingress-nginx"
  }
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.hosts"
    value = "{argo.${var.cluster_domain_name}}"
  }
  #  set {
  #    name = "server.ingress.https"
  #    value = "true"
  #  }
  set {
    name  = "controller.service.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "false"
  }
  set {
    name  = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = "argo.${var.cluster_domain_name}"
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
    value = aws_acm_certificate.cluster_domain.arn
  }
}

#
#resource "aws_route53_record" "argo_cd" {
#  zone_id = data.aws_route53_zone.cluster_domain.id
#  name    = "argo.${var.cluster_domain_name}"
#  type    = "A"
#
#  alias {
#    name                   = local.lb_hostname
#    zone_id                = data.aws_lb.ingress_nginx.zone_id
#    evaluate_target_health = true
#  }
#}
