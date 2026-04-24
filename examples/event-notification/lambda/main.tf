# -- examples/event-notification/lambda/main.tf (Example)
# ============================================================================
# Example: S3 Event Notification with Lambda
#
# This example creates S3 event notifications to Lambda functions.
# ============================================================================

module "s3_notification" {
  source = "../../../modules/event-notification"

  bucket_name = var.bucket_name

  lambda_notifications = var.lambda_notifications
}
