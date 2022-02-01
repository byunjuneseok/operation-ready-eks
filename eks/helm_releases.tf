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

resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.1.1"
  namespace  = "prometheus"
  atomic     = true
  timeout    = 900
  values     = [
    yamlencode({
      "podSecurityPolicy.enabled" : true
      "server.persistentVolume.enabled" : false
      "server.resources" : {
        limits   = {
          cpu    = "200m"
          memory = "50Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "30Mi"
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.prometheus]
}

#
#resource "helm_release" "grafana" {
#  chart      = "grafana"
#  name       = "grafana"
#  repository = "https://grafana.github.io/helm-charts"
#  version    = "6.21.2"
#  namespace  = "grafana"
#  atomic     = true
#  timeout    = 900
#  values     = [
#    yamlencode({
#      "persistence.enabled" : false
#      "datasources.datasources.yaml" : {
#        "apiVersion" : 1
#        "datasources" : [
#          {
#            "name" : "Prometheus"
#            "type" : "prometheus"
#            "url" : "http://prometheus-server.prometheus.svc.cluster.local"
#            "access" : "proxy"
#            "isDefault" : "true"
#          }
#        ]
#      }
#    })
#  ]
#
#  depends_on = [kubernetes_namespace.grafana]
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
