# S3 Bucket with Versioning

Creates an S3 bucket with versioning enabled.

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

terraform apply -var='s3={"bucket_name":"my-versioned-bucket","versioning":true}'
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| s3.bucket_name | Name of the S3 bucket | string | - |
| s3.versioning | Enable versioning | bool | true |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| versioning_status | Whether versioning is enabled |
