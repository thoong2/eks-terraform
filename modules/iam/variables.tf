variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "custom_cluster_policies" {
  description = "List of custom policy statements for the EKS cluster"
  type        = list(any)
  default     = []
}

variable "node_group_policies" {
  description = "Map of node group names to their custom policy statements"
  type        = map(list(any))
  default     = {}
}
