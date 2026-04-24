# -- examples/event-notification/sqs/versions.tf (Example)
# ============================================================================
# Example: S3 Event Notification with SQS - Version Requirements
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
