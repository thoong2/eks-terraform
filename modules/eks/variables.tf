variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_groups" {
  type = map(object({
    instance_type  = string
    ami_id         = string
    min_size      = number
    max_size      = number
    desired_size  = number
    disk_size     = number
  }))
}