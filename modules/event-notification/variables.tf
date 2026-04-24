# -- modules/event-notification/variables.tf (Child Module)
# ============================================================================
# S3 Event Notification Module - Variables
# ============================================================================

variable "enabled" {
  description = "Whether to create the S3 event notification"
  type        = bool
  default     = true
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

variable "lambda_notifications" {
  description = "List of Lambda function notification configurations"
  type = list(object({
    id                  = string
    lambda_function_arn = string
    events              = optional(list(string), ["s3:ObjectCreated:*"])
    filter_prefix       = optional(string)
    filter_suffix       = optional(string)
  }))
  default = []
}
