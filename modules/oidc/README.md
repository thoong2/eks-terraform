# EKS OIDC Provider and IAM Roles Module

This module creates:
1. OIDC Provider for EKS cluster
2. Multiple IAM roles for Kubernetes service accounts
3. IAM policies attached to roles

## Usage

```hcl
module "eks_oidc" {
  source = "./modules/eks-oidc"
  
  cluster_name = "my-eks-cluster"
  environment  = "dev"
  
  service_accounts = {
    "app1" = {
      namespace = "app1-namespace"
      name      = "app1-service-account"
      iam_role = {
        name = "app1-role"
        policies = {
          s3_access = {
            actions = ["s3:GetObject"]
            resources = ["arn:aws:s3:::my-bucket/*"]
          }
        }
      }
    }
  }
  
  tags = {
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| cluster_name | Name of the EKS cluster | string | yes |
| environment | Environment name | string | yes |
| service_accounts | Map of service accounts and their IAM roles configuration | map(object) | yes |
| tags | A map of tags to add to all resources | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| service_account_roles | Map of service account names to their IAM role ARNs |
| oidc_provider_arn | ARN of the OIDC provider |