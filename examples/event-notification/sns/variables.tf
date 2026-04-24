# -- examples/event-notification/sns/variables.tf (Example)
# ============================================================================
# Example: S3 Event Notification with SNS - Variables
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

variable "sns_notifications" {
  description = "List of SNS topic notification configurations"
  type = list(object({
    id            = string
    topic_arn     = string
    events        = optional(list(string), ["s3:ObjectCreated:*"])
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}
