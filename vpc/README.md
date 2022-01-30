# Configure networks

## Objectives
- Build VPC with multiple azs.
- Build private and public subnets.


## Prerequisite
- terraform

## How to build
```shell
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars # Edit file for deployment

terraform init
terraform plan
terraform apply
```

## How to destroy
```shell
terraform destroy
```


## Reference
- https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
