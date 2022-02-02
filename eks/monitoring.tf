resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.1.1"
  namespace  = "monitoring"
  atomic     = true
  timeout    = 900

  set{
    name = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
  }
  set{
    name = "server.persistentVolume.storageClass"
    value = "gp2"
  }
  set{
    name = "pushgateway.persistentVolume.storageClass"
    value = "gp2"
  }

  depends_on = [kubernetes_namespace.monitoring]
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "6.21.2"
  namespace  = "monitoring"
  atomic     = true
  timeout    = 900
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = 1
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-server.monitoring.svc.cluster.local"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].access"
    value = "proxy"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
    value = "true"
  }
  set {
    name  = "grafana\\.ini.server.domain"
    value = "grafana.${var.cluster_domain_name}"
  }
  set {
    name  = "grafana\\.ini.server.root_url"
    value = "http://grafana.${var.cluster_domain_name}"
  }
  set {
    name  = "adminPassword"
    value = "admin"
  }

  depends_on = [kubernetes_namespace.monitoring]
}

resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.cluster_domain.id
  name    = "grafana.${var.cluster_domain_name}"
  type    = "A"

  alias {
    name                   = local.lb_hostname
    zone_id                = data.aws_lb.ingress_nginx.zone_id
    evaluate_target_health = true
  }
}
