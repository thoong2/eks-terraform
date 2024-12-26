variable "region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "node_groups" {
  description = "EKS node groups configuration"
  type = map(object({
    instance_type  = string
    ami_id         = string
    min_size      = number
    max_size      = number
    desired_size  = number
    disk_size     = number
  }))
}