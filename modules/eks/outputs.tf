output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint URL of the EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "The certificate authority data of the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_groups" {
  description = "The node groups configuration"
  value = {
    for ng_name, ng in aws_eks_node_group.main : ng_name => {
      node_group_name = ng.node_group_name
      instance_types  = ng.instance_types
      ami_type        = ng.ami_type
      capacity_type   = ng.capacity_type
      scaling_config  = ng.scaling_config
      subnet_ids      = ng.subnet_ids
      taints          = ng.taint
      labels          = ng.labels
      tags            = ng.tags
    }
  }
}

output "node_group_names" {
  description = "The names of the node groups"
  value = [for ng in aws_eks_node_group.main : ng.node_group_name]
}

output "node_group_arns" {
  description = "The ARNs of the node groups"
  value = [for ng in aws_eks_node_group.main : ng.arn]
}
