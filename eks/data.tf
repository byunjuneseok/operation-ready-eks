locals {
  common_tags = {
    Name        = var.cluster_name
    Terraform   = true
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "cluster_vpc" {
  tags = {
      Name = var.cluster_name
      Terraform = true
      Environment = var.environment
  }
}

data "aws_subnet_ids" "cluster_vpc_public_subnets" {
  vpc_id = data.aws_vpc.cluster_vpc.id
  tags = {
        type = "public"
  }
}

data "aws_subnet_ids" "cluster_vpc_private_subnets" {
  vpc_id = data.aws_vpc.cluster_vpc.id
  tags = {
        type = "private"
  }
}
