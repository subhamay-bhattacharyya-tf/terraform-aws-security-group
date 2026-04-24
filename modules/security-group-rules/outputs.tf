output "ingress_rule_ids" {
  description = "Map of logical keys to ingress rule IDs."
  value       = { for k, r in aws_vpc_security_group_ingress_rule.this : k => r.id }
}

output "ingress_rule_arns" {
  description = "Map of logical keys to ingress rule ARNs."
  value       = { for k, r in aws_vpc_security_group_ingress_rule.this : k => r.arn }
}

output "egress_rule_ids" {
  description = "Map of logical keys to egress rule IDs."
  value       = { for k, r in aws_vpc_security_group_egress_rule.this : k => r.id }
}

output "egress_rule_arns" {
  description = "Map of logical keys to egress rule ARNs."
  value       = { for k, r in aws_vpc_security_group_egress_rule.this : k => r.arn }
}
