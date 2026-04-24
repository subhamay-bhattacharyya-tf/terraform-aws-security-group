# -- examples/event-notification/sqs/main.tf (Example)
# ============================================================================
# Example: S3 Event Notification with SQS
#
# This example creates S3 event notifications to SQS queues.
# ============================================================================

module "s3_notification" {
  source = "../../../modules/event-notification"

  bucket_name = var.bucket_name

  sqs_notifications = var.sqs_notifications
}
