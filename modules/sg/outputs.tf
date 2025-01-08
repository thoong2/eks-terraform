output "security_group_ids" {
  description = "IDs of the created security groups"
  value       = { for sg in aws_security_group.this : sg.key => sg.value.id }
}
