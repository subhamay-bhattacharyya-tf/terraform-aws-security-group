locals {
  ingress_rules = { for k, v in var.rules : k => v if v.type == "ingress" }
  egress_rules  = { for k, v in var.rules : k => v if v.type == "egress" }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_rules

  security_group_id = each.value.security_group_id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  referenced_security_group_id = each.value.referenced_security_group_id
  prefix_list_id               = each.value.prefix_list_id

  description = each.value.description

  tags = merge(
    each.value.tags,
    {
      Name = each.key
    },
  )
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.egress_rules

  security_group_id = each.value.security_group_id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  referenced_security_group_id = each.value.referenced_security_group_id
  prefix_list_id               = each.value.prefix_list_id

  description = each.value.description

  tags = merge(
    each.value.tags,
    {
      Name = each.key
    },
  )
}
