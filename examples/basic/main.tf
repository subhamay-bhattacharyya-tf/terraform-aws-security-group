module "security_groups" {
  source = "../../modules/security-group"

  region = var.region

  security_groups = {
    web = {
      name        = "web-sg"
      description = "Web tier security group"
      vpc_id      = var.vpc_id
      tags = {
        Tier = "web"
      }
    }
  }
}

module "security_group_rules" {
  source = "../../modules/security-group-rules"

  region = var.region

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
    web_http_ingress = {
      security_group_id = module.security_groups.security_group_ids["web"]
      type              = "ingress"
      from_port         = 80
      to_port           = 80
      ip_protocol       = "tcp"
      cidr_ipv4         = "0.0.0.0/0"
      description       = "Allow HTTP from the internet"
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
