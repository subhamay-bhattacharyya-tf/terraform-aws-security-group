# S3 Bucket with Folders

Creates an S3 bucket with predefined folder structure (prefixes).

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

terraform apply -var='s3={"bucket_name":"my-data-bucket","bucket_keys":["raw-data/csv","raw-data/json","processed-data","archive"]}'
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| s3.bucket_name | Name of the S3 bucket | string | - |
| s3.bucket_keys | List of folder prefixes | list(string) | [] |
| s3.versioning | Enable versioning | bool | false |
| s3.sse_algorithm | Encryption algorithm | string | null |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_keys | The folder keys created |
