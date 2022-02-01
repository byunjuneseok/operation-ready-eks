resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    annotations = {
      name = "ingress-nginx"
    }
  name = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    annotations = {
      name = "prometheus"
    }
  name = "prometheus"
  }
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    annotations = {
      name = "grafana"
    }
  name = "grafana"
  }
}

resource "kubernetes_namespace" "argo-cd" {
  metadata {
    annotations = {
      name = "argo-cd"
    }
    name = "argo-cd"
  }
}

resource "kubernetes_namespace" "applications" {
  for_each = toset(var.application_namespaces)
  metadata {
    annotations = {
      name = each.key
    }
    name = each.key
  }
}
