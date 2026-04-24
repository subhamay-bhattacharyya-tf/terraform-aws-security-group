# -- examples/bucket/sse-kms/versions.tf (Example)
# ============================================================================
# Example: S3 Bucket with SSE-KMS Encryption - Version Requirements
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

provider "aws" {
  region = var.region
}
