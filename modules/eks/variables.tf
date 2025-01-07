variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    subnet_type = string
    node_group = object({
      instance_type   = list(string)
      ami_type        = string
      capacity_type   = string
      disk_size       = number
      scaling_config = object({
        min_size     = number
        max_size     = number
        desired_size = number
      })
      labels = map(string)
      taints = list(object({
        key    = string
        value  = string
        effect = string
      }))
      tags = map(string)
      policies = map(list(object({
        Effect   = string
        Action   = list(string)
        Resource = list(string)
      })))
    })
  }))
}

variable "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  type        = string
}

variable "node_group_role_arns" {
  description = "Map of node group IAM role ARNs"
  type        = map(string)
}

variable "private_subnet_ids_by_type" {
  description = "Map of private subnet IDs by subnet type"
  type        = map(list(string))
}

variable "public_subnet_ids_by_type" {
  description = "Map of public subnet IDs by subnet type"
  type        = map(list(string))
}