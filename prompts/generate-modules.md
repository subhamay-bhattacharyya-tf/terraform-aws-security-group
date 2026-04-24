# Prompt: Generate `terraform-aws-security-group` Modules

You are working in the `terraform-aws-security-group` repository. Generate a complete, production-ready Terraform module that provisions AWS security groups and their ingress/egress rules as two independent submodules.

## Context

- **Repository name:** `terraform-aws-security-group`
- **Provider:** AWS (`hashicorp/aws` >= 5.0.0)
- **Terraform:** >= 1.3.0
- **Design principle:** Split security groups and rules into separate submodules to avoid circular dependencies between cross-referencing SGs and prevent drift from inline rule blocks.

## Scope

Generate the following two submodules. Do **not** create a root-level `main.tf` — this repository is a collection of submodules consumed via `source = ".../modules/<name>"`.

### Submodule 1: `modules/security-group/`

Create these files:

**`main.tf`**

- Single `aws_security_group` resource, created via `for_each = var.security_groups`
- **No inline `ingress` or `egress` blocks** — rules are handled by the other submodule
- Fields from each map entry: `name`, `description` (default `"Managed by Terraform"`), `vpc_id`, `tags`
- Include `lifecycle { create_before_destroy = true }`

**`variables.tf`**

- `security_groups`: `map(object({...}))` with fields:
  - `name` (string, required)
  - `description` (optional string, default `"Managed by Terraform"`)
  - `vpc_id` (string, required)
  - `tags` (optional map(string), default `{}`)
- `region` (string, required)
- Validations:
  - `name` is non-empty and ≤ 255 chars
  - `vpc_id` matches `^vpc-[a-f0-9]+$`

**`outputs.tf`**

- `security_group_ids` — map of key → id
- `security_group_arns` — map of key → arn
- `security_group_names` — map of key → name
- `security_group_vpc_ids` — map of key → vpc_id

**`versions.tf`**

```hcl
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}
```

---

### Submodule 2: `modules/security-group-rules/`

Create these files:

**`main.tf`**

- Two locals that partition `var.rules` by `type`:
  - `ingress_rules = { for k, v in var.rules : k => v if v.type == "ingress" }`
  - `egress_rules  = { for k, v in var.rules : k => v if v.type == "egress" }`
- `aws_vpc_security_group_ingress_rule` via `for_each = local.ingress_rules`
- `aws_vpc_security_group_egress_rule` via `for_each = local.egress_rules`
- Pass through: `security_group_id`, `from_port`, `to_port`, `ip_protocol`, and exactly one of `cidr_ipv4` / `cidr_ipv6` / `referenced_security_group_id` / `prefix_list_id`, plus `description` and `tags`

**`variables.tf`**

- `rules`: `map(object({...}))` with fields:
  - `security_group_id` (string, required)
  - `type` (string, required — `"ingress"` or `"egress"`)
  - `from_port` (number, required)
  - `to_port` (number, required)
  - `ip_protocol` (string, required — one of `"tcp"`, `"udp"`, `"icmp"`, `"icmpv6"`, `"-1"`)
  - `cidr_ipv4` (optional string, default `null`)
  - `cidr_ipv6` (optional string, default `null`)
  - `referenced_security_group_id` (optional string, default `null`)
  - `prefix_list_id` (optional string, default `null`)
  - `description` (optional string, default `"Managed by Terraform"`)
  - `tags` (optional map(string), default `{}`)
- `region` (string, required)
- Validations:
  - `type` ∈ {`ingress`, `egress`}
  - `ip_protocol` ∈ {`tcp`, `udp`, `icmp`, `icmpv6`, `-1`}
  - `from_port` and `to_port` ∈ [0, 65535]
  - Exactly one of `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, `prefix_list_id` is non-null per rule

**`outputs.tf`**

- `ingress_rule_ids` — map of key → id
- `ingress_rule_arns` — map of key → arn
- `egress_rule_ids` — map of key → id
- `egress_rule_arns` — map of key → arn

**`versions.tf`** — same block as Submodule 1.

---

## Examples

Also generate:

### `examples/basic/`

- Consumes both submodules
- Creates one security group and 2–3 ingress/egress rules using `cidr_ipv4`
- Self-contained, validatable with `terraform init -backend=false && terraform validate`

### `examples/cross-referenced/`

- Two security groups (`alb` and `app`)
- `app` SG has an ingress rule that uses `referenced_security_group_id` pointing to the `alb` SG
- Demonstrates the split-module pattern solving the cross-reference case

---

## Coding standards

- Use `map(object({...}))` with `optional(...)` for defaults — do not use flat variables.
- The map key is a logical Terraform identifier only; the real AWS resource name must come from a `name` field inside the object.
- All validations belong in `variables.tf` via `validation` blocks — do not push validation into `main.tf`.
- Run `terraform fmt -recursive` on the output.
- Every resource must carry `tags` merged from the per-entry `tags` field.
- No hardcoded regions, account IDs, VPC IDs, or ARNs anywhere in the submodules.

## Deliverables checklist

- [ ] `modules/security-group/` with `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`
- [ ] `modules/security-group-rules/` with `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`
- [ ] `examples/basic/` — working end-to-end config
- [ ] `examples/cross-referenced/` — working end-to-end config with SG-to-SG reference
- [ ] All files pass `terraform fmt -check -recursive` and `terraform validate`
- [ ] Summary output listing every file created and every AWS resource type provisioned
