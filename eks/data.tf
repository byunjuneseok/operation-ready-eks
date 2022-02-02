locals {
  common_tags = {
    Name        = var.cluster_name
    Terraform   = true
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "eks_worker_node" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eks_cni_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "ecr_read_only" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_vpc" "cluster_vpc" {
  tags = {
    Name        = var.cluster_name
    Terraform   = true
    Environment = var.environment
  }
}

data "aws_subnet_ids" "cluster_vpc_public_subnets" {
  vpc_id = data.aws_vpc.cluster_vpc.id
  tags   = {
    type = "public"
  }
}

data "aws_subnet_ids" "cluster_vpc_private_subnets" {
  vpc_id = data.aws_vpc.cluster_vpc.id
  tags   = {
    type = "private"
  }
}

data "aws_route53_zone" "cluster_domain" {
  name = var.cluster_domain_name
}

locals {
  oidc_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.ingress_nginx_controller]
}

locals {
  lb_name = split("-", split(".", data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname).0).0
  lb_hostname = data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname
}

data "aws_lb" "ingress_nginx" {
  name = local.lb_name
}
