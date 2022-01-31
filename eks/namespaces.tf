resource "kubernetes_namespace" "ingress" {
  metadata {
    annotations = {
      name = "ingress"
    }
  name = "ingress"
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
