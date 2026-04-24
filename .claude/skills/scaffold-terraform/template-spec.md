# Terraform Template Specification

Generate these files across two submodule directories: `modules/security-group/` and `modules/security-group-rules/`.

---

## Module 1: `modules/security-group/`

**main.tf:**

- Single `aws_security_group` resource created via `for_each` over `var.security_groups`
- Do NOT use inline `ingress` or `egress` blocks — rules are managed in the separate `security-group-rules` submodule
- Pass through from each map entry:
  - `name`: from object field
  - `description`: from object field (default `"Managed by Terraform"`)
  - `vpc_id`: from object field
  - `tags`: from object field merged with common tags
- Include `lifecycle { create_before_destroy = true }` to avoid replacement issues

**variables.tf:**

- `security_groups`: `map(object({...}))` with fields:
  - `name` (string, required)
  - `description` (optional string, default `"Managed by Terraform"`)
  - `vpc_id` (string, required)
  - `tags` (optional map(string), default `{}`)
- Validations:
  - `name` is non-empty and ≤ 255 characters
  - `vpc_id` matches `^vpc-[a-f0-9]+$`

**outputs.tf:**

- `security_group_ids`: map of logical key → SG id
- `security_group_arns`: map of logical key → SG arn
- `security_group_names`: map of logical key → SG name
- `security_group_vpc_ids`: map of logical key → vpc id

**versions.tf:**

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

## Module 2: `modules/security-group-rules/`

**main.tf:**

- Split `var.rules` into two local maps by `type` field (`ingress` / `egress`)
- Create `aws_vpc_security_group_ingress_rule` via `for_each` over the ingress map
- Create `aws_vpc_security_group_egress_rule` via `for_each` over the egress map
- Pass through from each map entry:
  - `security_group_id`
  - `from_port`, `to_port`, `ip_protocol`
  - Exactly one of: `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, `prefix_list_id`
  - `description`
  - `tags` merged with common tags

**variables.tf:**

- `rules`: `map(object({...}))` with fields:
  - `security_group_id` (string, required)
  - `type` (string, required — must be `"ingress"` or `"egress"`)
  - `from_port` (number, required)
  - `to_port` (number, required)
  - `ip_protocol` (string, required — `"tcp"`, `"udp"`, `"icmp"`, `"icmpv6"`, or `"-1"`)
  - `cidr_ipv4` (optional string, default `null`)
  - `cidr_ipv6` (optional string, default `null`)
  - `referenced_security_group_id` (optional string, default `null`)
  - `prefix_list_id` (optional string, default `null`)
  - `description` (optional string, default `"Managed by Terraform"`)
  - `tags` (optional map(string), default `{}`)
- Validations:
  - `type` is one of `ingress` or `egress`
  - `ip_protocol` is one of the allowed values
  - `from_port` and `to_port` are between 0 and 65535
  - Exactly one source/destination field is set per rule (xor across `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, `prefix_list_id`)

**outputs.tf:**

- `ingress_rule_ids`: map of logical key → rule id
- `ingress_rule_arns`: map of logical key → rule arn
- `egress_rule_ids`: map of logical key → rule id
- `egress_rule_arns`: map of logical key → rule arn

**versions.tf:**

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

## `examples/`

- `examples/basic/` — single security group with a handful of ingress/egress rules using `cidr_ipv4`
- `examples/cross-referenced/` — two security groups (e.g., `alb` and `app`) where the `app` SG allows traffic from the `alb` SG via `referenced_security_group_id`

Each example should be a working, self-contained configuration that references both submodules and passes example values for all variables. Examples are validated separately from the root modules in CI.

---

## `test/`

This folder contains the integration test cases for both submodules. Tests are written in Go using the Terratest framework. They must:

- Provision real security groups and rules in AWS
- Assert the outputs of both submodules (IDs, ARNs, names)
- Verify that cross-referenced security group rules are wired correctly
- Destroy all resources after the test completes

At minimum, include:

- `security_group_basic_test.go` — exercises `examples/basic`
- `security_group_cross_referenced_test.go` — exercises `examples/cross-referenced`
- `helpers_test.go` — shared AWS test helpers (VPC lookup, region handling, tag assertions)

---

## `package.json`

Ensure the `name` field is always set to the repository name (`terraform-aws-security-group`).

## `package-lock.json`

Ensure the `name` field is always set to the repository name (`terraform-aws-security-group`).

## `CONTRIBUTING.md`

Ensure the **Reporting Issues** section always links to the current repository's issues page.

## `README.md`

The custom endpoint badge should always point to the current repository's `.json` metadata endpoint.
