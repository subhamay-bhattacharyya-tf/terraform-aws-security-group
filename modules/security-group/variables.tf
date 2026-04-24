variable "region" {
  type        = string
  description = "AWS region where the security groups will be created"
}

variable "security_groups" {
  type = map(object({
    name        = string
    description = optional(string, "Managed by Terraform")
    vpc_id      = string
    tags        = optional(map(string), {})
  }))
  description = "Map of security groups to create. The map key is a logical Terraform identifier; the real AWS resource name comes from the `name` field inside each object."

  validation {
    condition = alltrue([
      for k, v in var.security_groups : length(v.name) > 0 && length(v.name) <= 255
    ])
    error_message = "Each security group `name` must be non-empty and no longer than 255 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.security_groups : can(regex("^vpc-[a-f0-9]+$", v.vpc_id))
    ])
    error_message = "Each security group `vpc_id` must match the pattern ^vpc-[a-f0-9]+$."
  }
}
