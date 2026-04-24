# -- modules/event-notification/outputs.tf (Child Module)
# ============================================================================
# S3 Event Notification Module - Outputs
# ============================================================================

output "notification_configured" {
  description = "Whether S3 event notifications were configured"
  value       = var.enabled && (length(var.sqs_notifications) > 0 || length(var.sns_notifications) > 0 || length(var.lambda_notifications) > 0)
}

output "bucket_name" {
  description = "The S3 bucket name with notifications configured"
  value       = var.bucket_name
}

output "sqs_notification_count" {
  description = "Number of SQS notification configurations"
  value       = length(var.sqs_notifications)
}

output "sns_notification_count" {
  description = "Number of SNS notification configurations"
  value       = length(var.sns_notifications)
}

output "lambda_notification_count" {
  description = "Number of Lambda notification configurations"
  value       = length(var.lambda_notifications)
}
