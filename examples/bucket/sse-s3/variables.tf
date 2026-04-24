# -- examples/bucket/sse-s3/variables.tf (Example)
# ============================================================================
# Example: S3 Bucket with SSE-S3 Encryption - Variables
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
    sse_algorithm = optional(string, "AES256")
    kms_key_alias = optional(string, null)
  })
}
