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
