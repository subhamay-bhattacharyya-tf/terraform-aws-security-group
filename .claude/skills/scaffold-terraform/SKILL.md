---
name: scaffold-terraform
description: Generate complete Terraform AWS Module for provisioning security groups and their ingress/egress rules with the given specifications
disable-model-invocation: true
---

Generate a complete Terraform AWS Module for provisioning security groups and their ingress/egress rules with the given specifications:

Use $ARGUMENTS for optional overrides:
- $0 = AWS region (default: us-east-1)
- $1 = VPC ID variable name (default: vpc_id)

## What to Generate

Read `template-spec.md` in this skill folder for the full Terraform module specification.

Generate all files in the following submodule directories following the template spec:
- `modules/security-group/` — creates `aws_security_group` resources (no inline rules)
- `modules/security-group-rules/` — creates `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` resources

Each submodule must include:
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`

## After Generation

- [ ] List all files created across both submodules
- [ ] Show a summary of resources that will be provisioned (security groups and ingress/egress rules)
- [ ] Remind the engineer to review the files and run `/tf-plan` when ready