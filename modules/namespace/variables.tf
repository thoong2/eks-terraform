variable "environment" {
  description = "Name of environments (dev, staging, prod)"
  type        = string
}

variable "services" {
  description = "List of services to create namespaces for"
  type        = list(string)
}
