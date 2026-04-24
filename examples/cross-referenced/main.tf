module "security_groups" {
  source = "../../modules/security-group"

  region = var.region

  security_groups = {
    alb = {
      name        = "alb-sg"
      description = "ALB (public-facing) security group"
      vpc_id      = var.vpc_id
      tags = {
        Tier = "frontend"
      }
    }
    app = {
      name        = "app-sg"
      description = "Application tier security group"
      vpc_id      = var.vpc_id
      tags = {
        Tier = "backend"
      }
    }
  }
}

module "security_group_rules" {
  source = "../../modules/security-group-rules"

  region = var.region

  rules = {
    alb_https_ingress = {
      security_group_id = module.security_groups.security_group_ids["alb"]
      type              = "ingress"
      from_port         = 443
      to_port           = 443
      ip_protocol       = "tcp"
      cidr_ipv4         = "0.0.0.0/0"
      description       = "Allow HTTPS from the internet"
    }
    alb_to_app_egress = {
      security_group_id            = module.security_groups.security_group_ids["alb"]
      type                         = "egress"
      from_port                    = 8080
      to_port                      = 8080
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.security_groups.security_group_ids["app"]
      description                  = "Allow ALB to reach the app tier"
    }
    app_from_alb_ingress = {
      security_group_id            = module.security_groups.security_group_ids["app"]
      type                         = "ingress"
      from_port                    = 8080
      to_port                      = 8080
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.security_groups.security_group_ids["alb"]
      description                  = "Allow inbound from the ALB SG"
    }
  }
}
