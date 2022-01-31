resource "kubernetes_namespace" "ingress" {
  metadata {
    annotations = {
      name = "ingress"
    }
  name = "ingress"
  }
}
