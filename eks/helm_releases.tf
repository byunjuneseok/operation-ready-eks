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
#
#resource "helm_release" "prometheus" {
#  chart      = "prometheus"
#  name       = "prometheus"
#  repository = "https://prometheus-community.github.io/helm-charts"
#  version    = "15.1.1"
#  namespace  = "monitoring"
#  atomic     = true
#  timeout    = 900
#  depends_on = [kubernetes_namespace.monitoring]
#}
#
#resource "helm_release" "grafana" {
#  chart      = "grafana"
#  name       = "grafana"
#  repository = "https://grafana.github.io/helm-charts"
#  version    = "6.21.2"
#  namespace  = "monitoring"
#  atomic     = true
#  timeout    = 900
#  set {
#    name  = "service.type"
#    value = "LoadBalancer"
#  }
#  set {
#    name  = "datasources.datasources\\.yaml.apiVersion"
#    value = 1
#  }
#  set {
#    name  = "datasources.datasources\\.yaml.datasources[0].name"
#    value = "Prometheus"
#  }
#  set {
#    name  = "datasources.datasources\\.yaml.datasources[0].type"
#    value = "prometheus"
#  }
#  set {
#    name  = "datasources.datasources\\.yaml.datasources[0].url"
#    value = "http://prometheus-server.monitoring.svc.cluster.local"
#  }
#  set {
#    name  = "datasources.datasources\\.yaml.datasources[0].access"
#    value = "proxy"
#  }
#  set {
#    name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
#    value = "true"
#  }
#  set {
#    name  = "grafana\\.ini.server.domain"
#    value = "grafana.${var.cluster_domain_name}"
#  }
#  set {
#    name  = "grafana\\.ini.server.root_url"
#    value = "http://grafana.${var.cluster_domain_name}"
#  }
#  depends_on = [kubernetes_namespace.monitoring]
#}


#resource "helm_release" "argo-cd" {
#  chart = "argo-cd"
#  name  = "argo-cd"
#  repository = "https://argoproj.github.io/argo-helm"
#  version = "3.33.1"
#  namespace  = "argo-cd"
#  atomic     = true
#  timeout    = 900
#  values = [
#
#  ]
#}
