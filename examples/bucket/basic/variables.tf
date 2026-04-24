# -- examples/bucket/basic/variables.tf (Example)
# ============================================================================
# Example: Basic S3 Bucket - Variables
# ============================================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "s3" {
  description = "S3 bucket configuration"
  type = object({
    bucket_name   = string
    bucket_keys   = optional(list(string), [])
    versioning    = optional(bool, false)
    sse_algorithm = optional(string, null)
    kms_key_alias = optional(string, null)
  })
}
