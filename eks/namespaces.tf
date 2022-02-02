resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    annotations = {
      name = "ingress-nginx"
    }
  name = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "karpenter" {
  metadata {
    annotations = {
      name = "karpenter"
    }
    name = "karpenter"
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
