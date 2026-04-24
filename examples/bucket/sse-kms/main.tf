# -- examples/bucket/sse-kms/main.tf (Example)
# ============================================================================
# Example: S3 Bucket with SSE-KMS Encryption
#
# This example creates an S3 bucket with server-side encryption using AWS KMS-managed keys (SSE-KMS).
# ============================================================================

module "s3_bucket" {
  source = "../../../modules/bucket"

  s3_config = var.s3
}
