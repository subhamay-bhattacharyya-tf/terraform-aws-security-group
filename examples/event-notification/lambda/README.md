# S3 Event Notification with Lambda

Creates S3 event notifications to Lambda functions.

## Source

```hcl
module "s3_notification" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/event-notification?ref=main"

  bucket_name = "my-bucket"

  lambda_notifications = [
    {
      id                  = "process-uploads"
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
      events              = ["s3:ObjectCreated:*"]
      filter_suffix       = ".json"
    }
  ]
}
```

## Usage

```bash
terraform init

terraform apply \
  -var='bucket_name=my-bucket' \
  -var='lambda_notifications=[{"id":"process","lambda_function_arn":"arn:aws:lambda:us-east-1:123456789012:function:my-function"}]'
```

## Prerequisites

- S3 bucket must exist
- Lambda function must exist with appropriate permissions

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| bucket_name | Name of the S3 bucket | string | - |
| lambda_notifications | List of Lambda notification configurations | list(object) | [] |

### lambda_notifications Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| id | string | - | Unique identifier for the notification |
| lambda_function_arn | string | - | ARN of the Lambda function |
| events | list(string) | ["s3:ObjectCreated:*"] | S3 events to trigger notification |
| filter_prefix | string | null | Object key prefix filter |
| filter_suffix | string | null | Object key suffix filter |

## Outputs

| Name | Description |
|------|-------------|
| notification_configured | Whether notifications were configured |
| bucket_name | The S3 bucket name |
| lambda_notification_count | Number of Lambda notifications |
