variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_groups" {
  description = "Map of node group configurations including IAM policies"
  type = map(object({
    node_group = object({
      policies = list(string)
    })
  }))
}

variable "policies_path" {
  description = "Path to the directory containing policy JSON files. Can be absolute or relative path"
  type        = string
  default     = "./modules/policies"
  
  validation {
    condition     = can(regex("^[./]", var.policies_path))
    error_message = "The policies_path must start with ./ for relative path or / for absolute path."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
