# Terraform AWS Security Group Module

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-security-group)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/0904642f67938ca90257d8bf2a78ea13/raw/terraform-aws-security-group.json?)

A Terraform module for creating and managing AWS security groups and their ingress/egress rules as two independent submodules. The split-module design avoids circular dependencies between cross-referencing security groups and prevents drift caused by inline rule blocks on `aws_security_group`.

## Features

- Split-module design — security groups and rules are independent resources
- Single `map(object({...}))` input per submodule, consumed via `for_each`
- No inline `ingress`/`egress` blocks — all rules via `aws_vpc_security_group_ingress_rule` / `aws_vpc_security_group_egress_rule`
- Cross-references between security groups (e.g. ALB → app tier) without circular dependency
- Supports all rule source types: `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, `prefix_list_id`
- Built-in input validation (name length, `vpc_id` format, port ranges, protocol, mutual exclusivity of rule sources)
- `create_before_destroy` lifecycle on every security group

## Modules

| Module                                               | Description                                                                                      |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [security-group](modules/security-group)             | Creates `aws_security_group` resources (no inline rules)                                         |
| [security-group-rules](modules/security-group-rules) | Creates `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` resources |

## Usage

### Single security group with rules

```hcl
module "security_groups" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/modules/security-group?ref=main"

  region = "us-east-1"

  security_groups = {
    web = {
      name        = "web-sg"
      description = "Web tier security group"
      vpc_id      = "vpc-0123456789abcdef0"
      tags = {
        Tier = "web"
      }
    }
  }
}

module "security_group_rules" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/modules/security-group-rules?ref=main"

  region = "us-east-1"

  rules = {
    web_https_ingress = {
      security_group_id = module.security_groups.security_group_ids["web"]
      type              = "ingress"
      from_port         = 443
      to_port           = 443
      ip_protocol       = "tcp"
      cidr_ipv4         = "0.0.0.0/0"
      description       = "Allow HTTPS from the internet"
    }
    web_all_egress = {
      security_group_id = module.security_groups.security_group_ids["web"]
      type              = "egress"
      from_port         = 0
      to_port           = 0
      ip_protocol       = "-1"
      cidr_ipv4         = "0.0.0.0/0"
      description       = "Allow all egress"
    }
  }
}
```

### Cross-referenced security groups (ALB → app)

```hcl
module "security_groups" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/modules/security-group?ref=main"

  region = "us-east-1"

  security_groups = {
    alb = {
      name        = "alb-sg"
      description = "ALB (public-facing) security group"
      vpc_id      = "vpc-0123456789abcdef0"
    }
    app = {
      name        = "app-sg"
      description = "Application tier security group"
      vpc_id      = "vpc-0123456789abcdef0"
    }
  }
}

module "security_group_rules" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/modules/security-group-rules?ref=main"

  region = "us-east-1"

  rules = {
    alb_https_ingress = {
      security_group_id = module.security_groups.security_group_ids["alb"]
      type              = "ingress"
      from_port         = 443
      to_port           = 443
      ip_protocol       = "tcp"
      cidr_ipv4         = "0.0.0.0/0"
    }
    alb_to_app_egress = {
      security_group_id            = module.security_groups.security_group_ids["alb"]
      type                         = "egress"
      from_port                    = 8080
      to_port                      = 8080
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.security_groups.security_group_ids["app"]
    }
    app_from_alb_ingress = {
      security_group_id            = module.security_groups.security_group_ids["app"]
      type                         = "ingress"
      from_port                    = 8080
      to_port                      = 8080
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.security_groups.security_group_ids["alb"]
    }
  }
}
```

### Rule using an IPv6 CIDR

```hcl
module "security_group_rules" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/modules/security-group-rules?ref=main"

  region = "us-east-1"

  rules = {
    ipv6_https_ingress = {
      security_group_id = module.security_groups.security_group_ids["web"]
      type              = "ingress"
      from_port         = 443
      to_port           = 443
      ip_protocol       = "tcp"
      cidr_ipv6         = "::/0"
    }
  }
}
```

### Rule using a managed prefix list

```hcl
module "security_group_rules" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-security-group/modules/security-group-rules?ref=main"

  region = "us-east-1"

  rules = {
    s3_gateway_egress = {
      security_group_id = module.security_groups.security_group_ids["app"]
      type              = "egress"
      from_port         = 443
      to_port           = 443
      ip_protocol       = "tcp"
      prefix_list_id    = "pl-0123456789abcdef0"
    }
  }
}
```

## Examples

| Example                                       | Description                                                                                                |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| [basic](examples/basic)                       | Single security group with HTTPS/HTTP ingress and all-egress via `cidr_ipv4`                               |
| [cross-referenced](examples/cross-referenced) | Two security groups (`alb` and `app`) demonstrating SG-to-SG references via `referenced_security_group_id` |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.3.0  |
| aws       | >= 5.0.0  |

## Providers

| Name   | Version   |
| ------ | --------- |
| aws    | >= 5.0.0  |

## `security-group` submodule

### `security-group` inputs

| Name            | Description                                          | Type        | Default   | Required   |
| --------------- | ---------------------------------------------------- | ----------- | --------- | ---------- |
| region          | AWS region where the security groups will be created | string      | -         | yes        |
| security_groups | Map of security groups to create                     | map(object) | -         | yes        |

#### `security_groups` object properties

| Property    | Type        | Default                  | Description                                        |
| ----------- | ----------- | ------------------------ | -------------------------------------------------- |
| name        | string      | -                        | AWS resource name of the security group (required) |
| description | string      | `"Managed by Terraform"` | Security group description                         |
| vpc_id      | string      | -                        | VPC ID (must match `^vpc-[a-f0-9]+$`, required)    |
| tags        | map(string) | `{}`                     | Tags applied to the security group                 |

### `security-group` outputs

| Name                   | Description                                 |
| ---------------------- | ------------------------------------------- |
| security_group_ids     | Map of logical keys to security group IDs   |
| security_group_arns    | Map of logical keys to security group ARNs  |
| security_group_names   | Map of logical keys to security group names |
| security_group_vpc_ids | Map of logical keys to VPC IDs              |

## `security-group-rules` submodule

### `security-group-rules` inputs

| Name   | Description                                | Type        | Default   | Required   |
| ------ | ------------------------------------------ | ----------- | --------- | ---------- |
| region | AWS region where the rules will be created | string      | -         | yes        |
| rules  | Map of ingress/egress rules to create      | map(object) | -         | yes        |

#### `rules` object properties

| Property                     | Type        | Default                  | Description                                            |
| ---------------------------- | ----------- | ------------------------ | ------------------------------------------------------ |
| security_group_id            | string      | -                        | ID of the target security group (required)             |
| type                         | string      | -                        | `"ingress"` or `"egress"` (required)                   |
| from_port                    | number      | -                        | Start of the port range, 0–65535 (required)            |
| to_port                      | number      | -                        | End of the port range, 0–65535 (required)              |
| ip_protocol                  | string      | -                        | One of `tcp`, `udp`, `icmp`, `icmpv6`, `-1` (required) |
| cidr_ipv4                    | string      | `null`                   | IPv4 CIDR source/destination                           |
| cidr_ipv6                    | string      | `null`                   | IPv6 CIDR source/destination                           |
| referenced_security_group_id | string      | `null`                   | Source/destination security group ID                   |
| prefix_list_id               | string      | `null`                   | Managed prefix list ID                                 |
| description                  | string      | `"Managed by Terraform"` | Rule description                                       |
| tags                         | map(string) | `{}`                     | Tags applied to the rule                               |

Exactly one of `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, or `prefix_list_id` must be set per rule.

### `security-group-rules` outputs

| Name              | Description                              |
| ----------------- | ---------------------------------------- |
| ingress_rule_ids  | Map of logical keys to ingress rule IDs  |
| ingress_rule_arns | Map of logical keys to ingress rule ARNs |
| egress_rule_ids   | Map of logical keys to egress rule IDs   |
| egress_rule_arns  | Map of logical keys to egress rule ARNs  |

## Resources Created

### `security-group` resources

| Resource           | Description                                         |
| ------------------ | --------------------------------------------------- |
| aws_security_group | Security group (one per map entry, no inline rules) |

### `security-group-rules` resources

| Resource                            | Description                                              |
| ----------------------------------- | -------------------------------------------------------- |
| aws_vpc_security_group_ingress_rule | One ingress rule per map entry where `type == "ingress"` |
| aws_vpc_security_group_egress_rule  | One egress rule per map entry where `type == "egress"`   |

## Validation

All validation lives in each submodule's `variables.tf`:

- `security_groups[*].name` is non-empty and at most 255 characters
- `security_groups[*].vpc_id` matches `^vpc-[a-f0-9]+$`
- `rules[*].type` is one of `ingress`, `egress`
- `rules[*].ip_protocol` is one of `tcp`, `udp`, `icmp`, `icmpv6`, `-1`
- `rules[*].from_port` and `rules[*].to_port` are in `[0, 65535]`
- Exactly one of `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, `prefix_list_id` is non-null per rule

## Testing

The module includes a Terratest-based integration test that creates real security groups and rules, asserts the outputs, then destroys them:

```bash
cd test
go mod tidy
go test -v -timeout 30m -run TestSecurityGroupBasic ./security_group_basic_test.go ./helpers_test.go
```

AWS credentials must be configured via environment variables, AWS CLI profile, or (in CI) OIDC. `AWS_REGION` and `AWS_VPC_ID` are required.

## CI/CD Configuration

The CI workflow (`.github/workflows/ci.yaml`) runs on:

- Push to `main`, `feature/**`, and `bug/**` branches (when `modules/**`, `examples/**`, or `test/**` change)
- Pull requests to `main` (same path filter)
- Manual workflow dispatch

Jobs:

1. **terraform-validate** — `fmt -check`, `init`, `validate` on both submodules
2. **examples-validate** — `init` + `validate` on all `examples/*`
3. **security-group-terratest** — real AWS integration test via OIDC
4. **generate-changelog** — runs `git-cliff` on non-main branches
5. **semantic-release** — runs only on `main`; uses Conventional Commits to auto-version

### GitHub Secrets

| Secret         | Description                          |
| -------------- | ------------------------------------ |
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication |

### GitHub Variables

| Variable            | Description                                           | Default   |
| ------------------- | ----------------------------------------------------- | --------- |
| `AWS_REGION`        | AWS region for Terratest                              | -         |
| `AWS_VPC_ID`        | VPC ID used by Terratest to provision security groups | -         |
| `TERRAFORM_VERSION` | Terraform version for CI jobs                         | `1.3.0`   |
| `GO_VERSION`        | Go version for Terratest                              | `1.21`    |

## License

MIT License — see [LICENSE](LICENSE) for details.
