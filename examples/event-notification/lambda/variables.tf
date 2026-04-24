# -- examples/event-notification/lambda/variables.tf (Example)
# ============================================================================
# Example: S3 Event Notification with Lambda - Variables
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
