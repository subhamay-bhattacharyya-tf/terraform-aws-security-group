# -- examples/bucket/sse-s3/main.tf (Example)
# ============================================================================
# Example: S3 Bucket with SSE-S3 Encryption
#
# This example creates an S3 bucket with server-side encryption using S3-managed keys (SSE-S3).
# ============================================================================

module "s3_bucket" {
  source = "../../../modules/bucket"

  s3_config = var.s3
}
