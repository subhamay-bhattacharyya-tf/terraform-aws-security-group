# -- examples/bucket/folders/main.tf (Example)
# ============================================================================
# Example: S3 Bucket with Folders
#
# This example creates an S3 bucket with predefined folder structure.
# ============================================================================

module "s3_bucket" {
  source = "../../../modules/bucket"

  s3_config = var.s3
}
