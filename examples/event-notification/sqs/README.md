# S3 Event Notification with SQS

Creates S3 event notifications to SQS queues.

## Source

```hcl
module "s3_notification" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/event-notification?ref=main"

  bucket_name = "my-bucket"

  sqs_notifications = [
    {
      id            = "snowpipe-notification"
      queue_arn     = "arn:aws:sqs:us-east-1:123456789012:my-queue"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "raw-data/"
      filter_suffix = ".csv"
    }
  ]
}
```

## Usage

```bash
terraform init

terraform apply \
  -var='bucket_name=my-bucket' \
  -var='sqs_notifications=[{"id":"notify","queue_arn":"arn:aws:sqs:us-east-1:123456789012:my-queue"}]'
```

## Prerequisites

- S3 bucket must exist
- SQS queue must exist with appropriate permissions

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| bucket_name | Name of the S3 bucket | string | - |
| sqs_notifications | List of SQS notification configurations | list(object) | [] |

### sqs_notifications Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| id | string | - | Unique identifier for the notification |
| queue_arn | string | - | ARN of the SQS queue |
| events | list(string) | ["s3:ObjectCreated:*"] | S3 events to trigger notification |
| filter_prefix | string | null | Object key prefix filter |
| filter_suffix | string | null | Object key suffix filter |

## Outputs

| Name | Description |
|------|-------------|
| notification_configured | Whether notifications were configured |
| bucket_name | The S3 bucket name |
| sqs_notification_count | Number of SQS notifications |
