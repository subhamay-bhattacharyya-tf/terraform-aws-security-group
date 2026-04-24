# -- modules/bucket/variables.tf (Child Module)
# ============================================================================
# S3 Bucket Module - Variables
# ============================================================================

variable "s3_config" {
  description = "Configuration object for S3 bucket"
  type = object({
    bucket_name   = string
    bucket_keys   = optional(list(string), [])
    versioning    = optional(bool, false)
    sse_algorithm = optional(string, null) # "AES256" for SSE-S3, "aws:kms" for SSE-KMS
    kms_key_alias = optional(string, null)
    bucket_policy = optional(string, null)
  })

  validation {
    condition     = length(var.s3_config.bucket_name) > 0
    error_message = "Bucket name must not be empty."
  }

  validation {
    condition     = length(var.s3_config.bucket_name) <= 63
    error_message = "Bucket name must be 63 characters or less."
  }

  validation {
    condition     = var.s3_config.sse_algorithm == null ? true : contains(["AES256", "aws:kms"], var.s3_config.sse_algorithm)
    error_message = "sse_algorithm must be 'AES256' (SSE-S3) or 'aws:kms' (SSE-KMS)."
  }

  validation {
    condition     = var.s3_config.sse_algorithm != "aws:kms" || var.s3_config.kms_key_alias != null
    error_message = "kms_key_alias is required when sse_algorithm is 'aws:kms'."
  }
}
