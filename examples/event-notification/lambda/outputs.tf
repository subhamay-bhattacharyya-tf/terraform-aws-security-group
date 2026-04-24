# -- examples/event-notification/lambda/outputs.tf (Example)
# ============================================================================
# Example: S3 Event Notification with Lambda - Outputs
# ============================================================================

output "notification_configured" {
  description = "Whether S3 event notifications were configured"
  value       = module.s3_notification.notification_configured
}

output "bucket_name" {
  description = "The S3 bucket name with notifications configured"
  value       = module.s3_notification.bucket_name
}

output "lambda_notification_count" {
  description = "Number of Lambda notification configurations"
  value       = module.s3_notification.lambda_notification_count
}
