variable "aws_profile" {
  type = string
  description = "Profile of awscli"
  default = "default"
}

variable "cluster_name" {
  type = string
  description = "Cluster name"
}

variable "cluster_version" {
  type = string
  description = "The version of K8s"
  default = "1.21"
}

variable "cluster_region" {
  type = string
  description = "Cluster region"
}

variable "environment" {
  type = string
  description = "Environment (dev, prod, ...)"
}

variable "eks_managed_node_group_default_instance_types" {
  type = list(string)
  description = "List of instance types for EKS-managed node group default"
  default = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
}
