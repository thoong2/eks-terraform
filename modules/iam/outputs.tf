output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arns" {
  description = "Map of node group IAM role ARNs"
  value = {
    for k, v in aws_iam_role.node_group_role : k => v.arn
  }
}