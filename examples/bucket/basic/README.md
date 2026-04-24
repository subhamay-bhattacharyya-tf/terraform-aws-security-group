# S3 Bucket - Basic Example

Creates an S3 bucket with optional KMS encryption, versioning, and folder structure.

## Source

```hcl
module "s3_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/modules/bucket?ref=main"

  s3_config = var.s3
}
```

## Usage

```bash
# Initialize
terraform init

# Plan
terraform plan -var='s3={"bucket_name":"my-bucket","bucket_keys":["raw-data/csv","raw-data/json"],"versioning":true}'

# Apply
terraform apply -var='s3={"bucket_name":"my-bucket","bucket_keys":["raw-data/csv","raw-data/json"],"versioning":true}'

# With KMS encryption
terraform apply -var='s3={"bucket_name":"my-bucket","bucket_keys":["data"],"versioning":true,"kms_key_alias":"my-kms-key"}'
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| s3 | S3 bucket configuration object | object | - |

### s3 Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| bucket_name | string | - | Name of the S3 bucket (required) |
| bucket_keys | list(string) | [] | Folder prefixes to create |
| versioning | bool | false | Enable versioning |
| kms_key_alias | string | null | KMS key alias for encryption |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_domain_name | The bucket domain name |
| versioning_status | Whether versioning is enabled |
| bucket_keys | The folder keys created |

## Requirements

- Terraform >= 1.3.0
- AWS provider >= 5.0.0
- KMS key alias must exist if `kms_key_alias` is specified
