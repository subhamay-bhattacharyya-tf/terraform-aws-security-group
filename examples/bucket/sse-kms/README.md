# S3 Bucket with SSE-KMS Encryption

Creates an S3 bucket with server-side encryption using AWS KMS-managed keys (SSE-KMS).

## Source

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = var.s3
}
```

## Usage

```bash
terraform init

terraform apply -var='s3={"bucket_name":"my-sse-kms-bucket","sse_algorithm":"aws:kms","kms_key_alias":"my-kms-key"}'
```

## Prerequisites

- KMS key alias must exist before applying

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| s3.bucket_name | Name of the S3 bucket | string | - |
| s3.sse_algorithm | Encryption algorithm | string | aws:kms |
| s3.kms_key_alias | KMS key alias (required) | string | - |
| s3.versioning | Enable versioning | bool | false |
