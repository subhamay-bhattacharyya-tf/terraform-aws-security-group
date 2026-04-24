output "security_group_ids" {
  description = "Map of logical keys to security group IDs."
  value       = { for k, sg in aws_security_group.this : k => sg.id }
}

output "security_group_arns" {
  description = "Map of logical keys to security group ARNs."
  value       = { for k, sg in aws_security_group.this : k => sg.arn }
}

output "security_group_names" {
  description = "Map of logical keys to security group names."
  value       = { for k, sg in aws_security_group.this : k => sg.name }
}

output "security_group_vpc_ids" {
  description = "Map of logical keys to VPC IDs."
  value       = { for k, sg in aws_security_group.this : k => sg.vpc_id }
}
