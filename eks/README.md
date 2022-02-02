# Provisioning EKS

## Objectives
- Build stable kubernetes cluster.

# Prerequisite
- [Multi-AZ VPC](../vpc)
- [terraform](https://www.terraform.io/)
- [awscli](https://aws.amazon.com/ko/cli/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [helm](https://helm.sh/)

## Add your cluster configuration to local machine
```shell
aws eks --region <AWS_REGION> update-kubeconfig --name <CLUSTER_NAME>
```

## Provision your EKS cluster
```shell
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars # Edit file for deployment

terraform init
terraform plan
terraform apply
```

## Fix bug of `ingress-nginx`
> release argo-cd failed, and has been rolled back due to atomic being set: failed to create resource: Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": context deadline exceeded

```shell
kubectl delete validatingwebhookconfiguration ingress-nginx-admission
```

# Namespaces
| namespace | description |
| --------- | ----------- |
| `ingress` | namespace for ingress-nginx |
