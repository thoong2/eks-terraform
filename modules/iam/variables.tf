variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_group_policies" {
  description = "Map of node group names to their custom policy statements"
  type        = map(list(any))
  default     = {}
}
