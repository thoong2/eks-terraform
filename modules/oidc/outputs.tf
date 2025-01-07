output "service_account_roles" {
  description = "Map of service account names to their IAM role ARNs"
  value = {
    for sa_key, sa in var.service_accounts :
    sa.name => aws_iam_role.service_account[sa_key].arn
  }
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}