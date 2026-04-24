# -- examples/event-notification/sns/main.tf (Example)
# ============================================================================
# Example: S3 Event Notification with SNS
#
# This example creates S3 event notifications to SNS topics.
# ============================================================================

module "s3_notification" {
  source = "../../../modules/event-notification"

  bucket_name = var.bucket_name

  sns_notifications = var.sns_notifications
}
