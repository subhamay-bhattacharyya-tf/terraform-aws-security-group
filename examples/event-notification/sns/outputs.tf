# -- examples/event-notification/sns/outputs.tf (Example)
# ============================================================================
# Example: S3 Event Notification with SNS - Outputs
# ============================================================================

output "notification_configured" {
  description = "Whether S3 event notifications were configured"
  value       = module.s3_notification.notification_configured
}

output "bucket_name" {
  description = "The S3 bucket name with notifications configured"
  value       = module.s3_notification.bucket_name
}

output "sns_notification_count" {
  description = "Number of SNS notification configurations"
  value       = module.s3_notification.sns_notification_count
}
