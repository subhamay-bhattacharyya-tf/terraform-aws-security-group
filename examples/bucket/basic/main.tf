# -- examples/bucket/basic/main.tf (Example)
# ============================================================================
# Example: S3 Bucket with KMS encryption and versioning
#
# This example demonstrates how to use the aws-s3-bucket module
# to create an S3 bucket with optional KMS encryption, versioning, and folders.
# ============================================================================

module "s3_bucket" {
  source = "../../../modules/bucket"

  s3_config = var.s3
}
