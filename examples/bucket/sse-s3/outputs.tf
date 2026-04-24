# -- examples/bucket/sse-s3/outputs.tf (Example)
# ============================================================================
# Example: S3 Bucket with SSE-S3 Encryption - Outputs
# ============================================================================

output "bucket_id" {
  description = "The name of the bucket"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.s3_bucket.bucket_arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3_bucket.bucket_domain_name
}

output "versioning_status" {
  description = "Whether versioning is enabled"
  value       = module.s3_bucket.versioning_status
}
