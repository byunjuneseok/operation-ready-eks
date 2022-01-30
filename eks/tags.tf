locals {
  common_tags = {
    Name        = var.cluster_name
    Terraform   = true
    Environment = var.environment
  }
}