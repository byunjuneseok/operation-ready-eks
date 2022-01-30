module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.11.0"

    name = var.cluster_name
    cidr = var.vpc_cidr_block

    azs                 = var.vpc_azs
    private_subnets     = var.vpc_private_subnets
    public_subnets      = var.vpc_public_subnets

    database_subnets    = var.vpc_database_subnets
    elasticache_subnets = var.vpc_elasticache_subnets

    enable_nat_gateway = true
    enable_vpn_gateway = true

    tags = {
        Name = var.cluster_name
        Terraform = true
        Environment = var.environment
    }

    private_subnet_tags = {
        type = "private"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb"           = "1"
    }

    public_subnet_tags = {
        type = "public"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                    = "1"
    }

    database_subnet_tags = {
        type = "database"
    }

    elasticache_subnet_tags = {
        type = "elasticache"
    }
}
