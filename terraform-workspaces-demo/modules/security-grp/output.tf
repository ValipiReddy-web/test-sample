output "security_group_id" {
  description = "ID of the existing security group"
  value       = data.aws_security_group.existing_sg.id
}
