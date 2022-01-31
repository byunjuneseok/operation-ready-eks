locals {
  kube_config = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.cluster.token
      }
    }]
  })

  admin_users_map_config = templatefile(
    "${path.module}/aws_auth_template.yml",
    {
      account_id = data.aws_caller_identity.current.account_id
      admin_users = ["agd"]
    })
}

resource "null_resource" "patch" {
  triggers = {
    kube_config = base64encode(local.kube_config)
    cmd_patch  = "kubectl patch configmap/aws-auth --patch \"${module.eks.aws_auth_configmap_yaml}\" -n kube-system --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kube_config
    }
    command = self.triggers.cmd_patch
  }
}


resource "null_resource" "patch_admin" {
  triggers = {
    order = null_resource.patch.id
    kube_config = base64encode(local.kube_config)
    cmd_patch  = "kubectl patch configmap/aws-auth --patch \"${local.admin_users_map_config}\" -n kube-system --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kube_config
    }
    command = self.triggers.cmd_patch
  }
}