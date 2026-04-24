# S3 Event Notification with SNS

Creates S3 event notifications to SNS topics.

## Source

```hcl
module "s3_notification" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/event-notification?ref=main"

  bucket_name = "my-bucket"

  sns_notifications = [
    {
      id            = "upload-notification"
      topic_arn     = "arn:aws:sns:us-east-1:123456789012:my-topic"
      events        = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
      filter_prefix = "uploads/"
    }
  ]
}
```

## Usage

```bash
terraform init

terraform apply \
  -var='bucket_name=my-bucket' \
  -var='sns_notifications=[{"id":"notify","topic_arn":"arn:aws:sns:us-east-1:123456789012:my-topic"}]'
```

## Prerequisites

- S3 bucket must exist
- SNS topic must exist with appropriate permissions

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| bucket_name | Name of the S3 bucket | string | - |
| sns_notifications | List of SNS notification configurations | list(object) | [] |

### sns_notifications Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| id | string | - | Unique identifier for the notification |
| topic_arn | string | - | ARN of the SNS topic |
| events | list(string) | ["s3:ObjectCreated:*"] | S3 events to trigger notification |
| filter_prefix | string | null | Object key prefix filter |
| filter_suffix | string | null | Object key suffix filter |

## Outputs

| Name | Description |
|------|-------------|
| notification_configured | Whether notifications were configured |
| bucket_name | The S3 bucket name |
| sns_notification_count | Number of SNS notifications |
