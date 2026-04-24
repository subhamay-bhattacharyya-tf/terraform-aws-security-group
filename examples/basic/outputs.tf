output "security_group_ids" {
  description = "Map of logical keys to security group IDs."
  value       = module.security_groups.security_group_ids
}

output "ingress_rule_ids" {
  description = "Map of logical keys to ingress rule IDs."
  value       = module.security_group_rules.ingress_rule_ids
}

output "egress_rule_ids" {
  description = "Map of logical keys to egress rule IDs."
  value       = module.security_group_rules.egress_rule_ids
}
