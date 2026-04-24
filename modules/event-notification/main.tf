# -- modules/event-notification/main.tf (Child Module)
# ============================================================================
# S3 Event Notification Module for SQS, SNS, and Lambda
# ============================================================================

resource "aws_s3_bucket_notification" "this" {
  count  = var.enabled ? 1 : 0
  bucket = var.bucket_name

  dynamic "queue" {
    for_each = var.sqs_notifications
    content {
      id            = queue.value.id
      queue_arn     = queue.value.queue_arn
      events        = lookup(queue.value, "events", ["s3:ObjectCreated:*"])
      filter_prefix = lookup(queue.value, "filter_prefix", null)
      filter_suffix = lookup(queue.value, "filter_suffix", null)
    }
  }

  dynamic "topic" {
    for_each = var.sns_notifications
    content {
      id            = topic.value.id
      topic_arn     = topic.value.topic_arn
      events        = lookup(topic.value, "events", ["s3:ObjectCreated:*"])
      filter_prefix = lookup(topic.value, "filter_prefix", null)
      filter_suffix = lookup(topic.value, "filter_suffix", null)
    }
  }

  dynamic "lambda_function" {
    for_each = var.lambda_notifications
    content {
      id                  = lambda_function.value.id
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lookup(lambda_function.value, "events", ["s3:ObjectCreated:*"])
      filter_prefix       = lookup(lambda_function.value, "filter_prefix", null)
      filter_suffix       = lookup(lambda_function.value, "filter_suffix", null)
    }
  }
}
