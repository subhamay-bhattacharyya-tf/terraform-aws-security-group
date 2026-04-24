# -- examples/bucket/versioning/main.tf (Example)
# ============================================================================
# Example: S3 Bucket with Versioning
#
# This example creates an S3 bucket with versioning enabled.
# ============================================================================

module "s3_bucket" {
  source = "../../../modules/bucket"

  s3_config = var.s3
}
