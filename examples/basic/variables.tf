variable "region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created."
}
