# -- modules/bucket/versions.tf (Child Module)
# ============================================================================
# S3 Bucket Module - Version Requirements
# ============================================================================

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}
