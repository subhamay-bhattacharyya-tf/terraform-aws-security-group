# -- examples/bucket/versioning/variables.tf (Example)
# ============================================================================
# Example: S3 Bucket with Versioning - Variables
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
    versioning    = optional(bool, true)
    sse_algorithm = optional(string, null)
    kms_key_alias = optional(string, null)
  })
}
