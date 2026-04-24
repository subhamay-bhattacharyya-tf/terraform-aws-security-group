# S3 Bucket with SSE-S3 Encryption

Creates an S3 bucket with server-side encryption using S3-managed keys (SSE-S3).

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

terraform apply -var='s3={"bucket_name":"my-sse-s3-bucket","sse_algorithm":"AES256"}'
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| s3.bucket_name | Name of the S3 bucket | string | - |
| s3.sse_algorithm | Encryption algorithm | string | AES256 |
| s3.versioning | Enable versioning | bool | false |
