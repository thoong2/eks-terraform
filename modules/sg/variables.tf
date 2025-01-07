variable "security_groups" {
  description = "Map of security groups to create"
  type = map(object({
    description = string
    ingress = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
    egress = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
    tags = map(string)
  }))
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}
