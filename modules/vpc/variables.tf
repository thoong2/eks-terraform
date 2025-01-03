variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  description = "Map of public subnet configurations"
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
}

variable "private_subnets" {
  description = "Map of private subnet configurations"
  type = map(object({
    name  = string
    cidrs = list(string)
  }))
}