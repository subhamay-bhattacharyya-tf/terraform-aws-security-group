# Terraform AWS S3 Bucket Module

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-s3)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/dd8a07e256e7af69c3de7f120a895d97/raw/terraform-aws-s3.json?)

A Terraform module for creating and managing AWS S3 buckets with optional encryption (SSE-S3 or SSE-KMS), versioning, folder structure, bucket policy, and event notifications.

## Features

- JSON-style configuration input
- Server-side encryption with SSE-S3 (AES256) or SSE-KMS
- Configurable versioning
- Automatic folder/prefix creation
- Public access blocked by default
- Optional bucket policy
- Event notifications for SQS, SNS, and Lambda
- Built-in input validation

## Modules

| Module | Description |
|--------|-------------|
| [bucket](modules/bucket) | S3 bucket with encryption, versioning, and folders |
| [event-notification](modules/event-notification) | S3 event notifications for SQS, SNS, and Lambda |

## Usage

### Basic S3 Bucket

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = {
    bucket_name = "my-bucket"
  }
}
```

### S3 Bucket with Versioning

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = {
    bucket_name = "my-versioned-bucket"
    versioning  = true
  }
}
```

### S3 Bucket with SSE-S3 Encryption

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = {
    bucket_name   = "my-encrypted-bucket"
    sse_algorithm = "AES256"
  }
}
```

### S3 Bucket with SSE-KMS Encryption

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = {
    bucket_name   = "my-kms-bucket"
    sse_algorithm = "aws:kms"
    kms_key_alias = "my-kms-key"
  }
}
```

### S3 Bucket with Folders

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = {
    bucket_name = "my-data-bucket"
    bucket_keys = ["raw-data/csv", "raw-data/json", "processed"]
  }
}
```

### S3 Bucket with Bucket Policy

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = {
    bucket_name   = "my-policy-bucket"
    bucket_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "AllowSSLRequestsOnly"
          Effect    = "Deny"
          Principal = "*"
          Action    = "s3:*"
          Resource = [
            "arn:aws:s3:::my-policy-bucket",
            "arn:aws:s3:::my-policy-bucket/*"
          ]
          Condition = {
            Bool = {
              "aws:SecureTransport" = "false"
            }
          }
        }
      ]
    })
  }
}
```

### S3 Event Notification with SQS

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

### S3 Event Notification with SNS

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

### S3 Event Notification with Lambda

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

### S3 Event Notification with Multiple Targets

```hcl
module "s3_notification" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/event-notification?ref=main"

  bucket_name = "my-bucket"

  sqs_notifications = [
    {
      id        = "queue-notification"
      queue_arn = "arn:aws:sqs:us-east-1:123456789012:my-queue"
      events    = ["s3:ObjectCreated:*"]
    }
  ]

  sns_notifications = [
    {
      id        = "topic-notification"
      topic_arn = "arn:aws:sns:us-east-1:123456789012:my-topic"
      events    = ["s3:ObjectRemoved:*"]
    }
  ]

  lambda_notifications = [
    {
      id                  = "lambda-notification"
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
      events              = ["s3:ObjectCreated:Put"]
      filter_prefix       = "processed/"
    }
  ]
}
```

### Using JSON Input

```bash
terraform apply -var='region=us-east-1' -var='s3={"bucket_name":"my-bucket","bucket_keys":["raw-data/csv","raw-data/json"],"versioning":true,"sse_algorithm":"aws:kms","kms_key_alias":"SB-KMS"}'
```

## Examples

### Bucket Examples

| Example | Description |
|---------|-------------|
| [basic](examples/bucket/basic) | Simple S3 bucket |
| [versioning](examples/bucket/versioning) | S3 bucket with versioning enabled |
| [sse-s3](examples/bucket/sse-s3) | S3 bucket with SSE-S3 encryption |
| [sse-kms](examples/bucket/sse-kms) | S3 bucket with SSE-KMS encryption |
| [folders](examples/bucket/folders) | S3 bucket with folder structure |

### Event Notification Examples

| Example | Description |
|---------|-------------|
| [sqs](examples/event-notification/sqs) | S3 event notification to SQS |
| [sns](examples/event-notification/sns) | S3 event notification to SNS |
| [lambda](examples/event-notification/lambda) | S3 event notification to Lambda |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| s3_config | Configuration object for S3 bucket | `object` | - | yes |

### s3_config Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| bucket_name | string | - | Name of the S3 bucket (required) |
| bucket_keys | list(string) | [] | List of folder prefixes to create |
| versioning | bool | false | Enable versioning on the bucket |
| sse_algorithm | string | null | Encryption algorithm: `AES256` (SSE-S3) or `aws:kms` (SSE-KMS) |
| kms_key_alias | string | null | KMS key alias (required when sse_algorithm is `aws:kms`) |
| bucket_policy | string | null | JSON bucket policy document |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_domain_name | The bucket domain name |
| versioning_enabled | Whether versioning is enabled |
| bucket_keys | The bucket keys created in the bucket |
| bucket_region | The AWS region where the bucket is located |

## Event Notification Module

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| enabled | Whether to create the S3 event notification | bool | true | no |
| bucket_name | Name of the S3 bucket to configure notifications for | string | - | yes |
| sqs_notifications | List of SQS queue notification configurations | list(object) | [] | no |
| sns_notifications | List of SNS topic notification configurations | list(object) | [] | no |
| lambda_notifications | List of Lambda function notification configurations | list(object) | [] | no |

### SQS Notification Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| id | string | - | Unique identifier for the notification |
| queue_arn | string | - | ARN of the SQS queue |
| events | list(string) | ["s3:ObjectCreated:*"] | S3 events to trigger notification |
| filter_prefix | string | null | Object key prefix filter |
| filter_suffix | string | null | Object key suffix filter |

### SNS Notification Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| id | string | - | Unique identifier for the notification |
| topic_arn | string | - | ARN of the SNS topic |
| events | list(string) | ["s3:ObjectCreated:*"] | S3 events to trigger notification |
| filter_prefix | string | null | Object key prefix filter |
| filter_suffix | string | null | Object key suffix filter |

### Lambda Notification Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| id | string | - | Unique identifier for the notification |
| lambda_function_arn | string | - | ARN of the Lambda function |
| events | list(string) | ["s3:ObjectCreated:*"] | S3 events to trigger notification |
| filter_prefix | string | null | Object key prefix filter |
| filter_suffix | string | null | Object key suffix filter |

### Event Notification Outputs

| Name | Description |
|------|-------------|
| notification_configured | Whether S3 event notifications were configured |
| bucket_name | The S3 bucket name with notifications configured |
| sqs_notification_count | Number of SQS notification configurations |
| sns_notification_count | Number of SNS notification configurations |
| lambda_notification_count | Number of Lambda notification configurations |

## Resources Created

### Bucket Module

| Resource | Description |
|----------|-------------|
| aws_s3_bucket | The S3 bucket |
| aws_s3_bucket_versioning | Versioning configuration |
| aws_s3_bucket_public_access_block | Blocks all public access |
| aws_s3_bucket_server_side_encryption_configuration | Encryption configuration (conditional) |
| aws_s3_bucket_policy | Bucket policy (conditional) |
| aws_s3_object | Folder placeholders (conditional) |

### Event Notification Module

| Resource | Description |
|----------|-------------|
| aws_s3_bucket_notification | S3 event notification configuration |

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty bucket name
- Bucket name exceeding 63 characters
- Invalid sse_algorithm value
- Missing kms_key_alias when using SSE-KMS

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

### Test Cases

| Test | Description |
|------|-------------|
| TestS3BucketBasic | Basic bucket creation |
| TestS3BucketVersioning | Bucket with versioning |
| TestS3BucketSSES3 | Bucket with SSE-S3 encryption |
| TestS3BucketSSEKMS | Bucket with SSE-KMS encryption |
| TestS3BucketWithFolders | Bucket with folder structure |

AWS credentials must be configured via environment variables or AWS CLI profile.

## CI/CD Configuration

The CI workflow runs on:
- Push to `main`, `feature/**`, and `bug/**` branches (when `modules/**` changes)
- Pull requests to `main` (when `modules/**` changes)
- Manual workflow dispatch

The workflow includes:
- Terraform validation and format checking
- Examples validation
- Terratest integration tests
- Changelog generation (non-main branches)
- Semantic release (main branch only)

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication |

### GitHub Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform version for CI jobs | `1.3.0` |
| `GO_VERSION` | Go version for Terratest | `1.21` |

## License

MIT License - See [LICENSE](LICENSE) for details.

## Breaking Changes

### v2.0.0

- **Module path changed**: The bucket module path changed from `modules/aws-s3-bucket` to `modules/bucket`. Update your source references accordingly.
- **Output renamed**: `versioning_enabled` output renamed to `versioning_status`.
- **Examples restructured**: Examples moved from `examples/<name>` to `examples/bucket/<name>` and `examples/event-notification/<name>`.
- **New event-notification module**: Added separate module for S3 event notifications supporting SQS, SNS, and Lambda.
