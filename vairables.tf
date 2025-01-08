# EKS
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}


# Namespaces
variable "namespaces" {
  description = "The EKS namespaces"
  type        = list(string)
}


# VPC
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDRs for public subnets"
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
}

variable "private_subnets" {
  description = "CIDRs for private subnets"
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
}


# Policies
variable "policies_path" {
  description = "Path to the directory containing policy JSON files. Can be absolute or relative path"
  type        = string
  default     = "./modules/policies"
  
  validation {
    condition     = can(regex("^[./]", var.policies_path))
    error_message = "The policies_path must start with ./ for relative path or / for absolute path."
  }
}


# Node groups
variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    subnet_type = string
    node_group = object({
      instance_types   = list(string)
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
      policies = list(string)
    })
  }))
}


# Service Accounts
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
