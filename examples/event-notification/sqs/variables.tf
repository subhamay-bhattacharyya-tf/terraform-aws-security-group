# -- examples/event-notification/sqs/variables.tf (Example)
# ============================================================================
# Example: S3 Event Notification with SQS - Variables
# ============================================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket to configure notifications for"
  type        = string
}

variable "sqs_notifications" {
  description = "List of SQS queue notification configurations"
  type = list(object({
    id            = string
    queue_arn     = string
    events        = optional(list(string), ["s3:ObjectCreated:*"])
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}
