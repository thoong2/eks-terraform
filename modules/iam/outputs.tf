output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_group_role_arns" {
  description = "ARNs of the node group IAM roles"
  value = {
    for ng_key, ng_value in aws_iam_role.node_groups :
    ng_key => ng_value.arn
  }
}

output "node_group_role_names" {
  description = "Names of the node group IAM roles"
  value = {
    for ng_key, ng_value in aws_iam_role.node_groups :
    ng_key => ng_value.name
  }
}
