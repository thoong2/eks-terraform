variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "service_accounts" {
  description = "Map of service accounts and their IAM roles configuration"
  type = map(object({
    namespace = string
    name      = string
    iam_role = object({
      name = string
      policies = map(object({
        actions   = list(string)
        resources = list(string)
      }))
    })
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
