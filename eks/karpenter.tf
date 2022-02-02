module "iam_assumable_role_karpenter" {
  source                        = "registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.10.1"
  create_role                   = true
  role_name                     = "${var.environment}-${var.cluster_name}-karpenter-controller"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
}

resource "aws_iam_policy" "karpenter_controller" {
  name   = "${var.environment}-${var.cluster_name}-karpenter-controller-policy"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "karpenter_node" {
  name                = "${var.environment}-${var.cluster_name}-karpenter-node"
  assume_role_policy  = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    data.aws_iam_policy.eks_worker_node.arn,
    data.aws_iam_policy.eks_cni_policy.arn,
    data.aws_iam_policy.ecr_read_only.arn,
    data.aws_iam_policy.ssm_managed_instance.arn
  ]
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "0.6.0"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }
  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "controller.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }
  # If you are NOT using the AWS CNI and using something else (like Calico),
  # you'll also need to tell the webhook to use host networking. So, add the following value to your Helm release:
  #set {
  #  name  = "webhook.hostNetwork"
  #  value = "true"
  #  type  = "string"
  #}
}
