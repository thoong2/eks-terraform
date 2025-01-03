# General variables
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

# VPC variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
}

# Node groups variables
variable "node_groups" {
  description = "Configuration for node groups"
  type = map(object({
    subnet_type = string
    node_group = object({
      instance_type   = list(string)
      ami_type        = string
      capacity_type   = string
      disk_size       = number
      scaling_config  = object({
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
      tags     = map(string)
      policies = map(list(object({
        Effect   = string
        Action   = list(string)
        Resource = list(string)
      })))
    })
  }))
}
