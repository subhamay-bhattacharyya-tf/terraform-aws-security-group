# -- examples/bucket/sse-kms/variables.tf (Example)
# ============================================================================
# Example: S3 Bucket with SSE-KMS Encryption - Variables
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
    sse_algorithm = optional(string, "aws:kms")
    kms_key_alias = string
  })
}
