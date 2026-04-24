variable "region" {
  type        = string
  description = "AWS region where the security group rules will be created."
}

variable "rules" {
  type = map(object({
    security_group_id            = string
    type                         = string
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    referenced_security_group_id = optional(string)
    prefix_list_id               = optional(string)
    description                  = optional(string, "Managed by Terraform")
    tags                         = optional(map(string), {})
  }))
  description = "Map of ingress/egress rules to create. The map key is a logical Terraform identifier; rules are partitioned by the `type` field."

  validation {
    condition = alltrue([
      for k, v in var.rules : contains(["ingress", "egress"], v.type)
    ])
    error_message = "Each rule `type` must be either `ingress` or `egress`."
  }

  validation {
    condition = alltrue([
      for k, v in var.rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], v.ip_protocol)
    ])
    error_message = "Each rule `ip_protocol` must be one of: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for k, v in var.rules :
      v.from_port >= 0 && v.from_port <= 65535 && v.to_port >= 0 && v.to_port <= 65535
    ])
    error_message = "Each rule `from_port` and `to_port` must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for k, v in var.rules :
      length([
        for s in [v.cidr_ipv4, v.cidr_ipv6, v.referenced_security_group_id, v.prefix_list_id] : s if s != null
      ]) == 1
    ])
    error_message = "Each rule must set exactly one of `cidr_ipv4`, `cidr_ipv6`, `referenced_security_group_id`, or `prefix_list_id`."
  }
}
