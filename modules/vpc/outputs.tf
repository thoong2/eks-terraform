output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids_by_type" {
  description = "Map of public subnet IDs by subnet type"
  value = {
    for subnet_key, subnet in var.public_subnets :
    subnet.name => [
      for az_index in range(length(subnet.cidrs)) :
      aws_subnet.public["${subnet_key}-${az_index}"].id
    ]
  }
}

output "private_subnet_ids_by_type" {
  description = "Map of private subnet IDs by subnet type"
  value = {
    for subnet_key, subnet in var.private_subnets :
    subnet.name => [
      for az_index in range(length(subnet.cidrs)) :
      aws_subnet.private["${subnet_key}-${az_index}"].id
    ]
  }
}