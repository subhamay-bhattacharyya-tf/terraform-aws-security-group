# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0 (2026-02-10)

### ⚠ BREAKING CHANGES

* reorganize examples and add event notification module
* Initial release of AWS S3 bucket module replacing Snowflake warehouse module

- Add S3 bucket module with SSE-S3 and SSE-KMS encryption options
- Add versioning support
- Add folder/prefix creation
- Add examples: basic, versioning, sse-s3, sse-kms, with-folders
- Add Terratest integration tests
- Update CI workflow for AWS

### Features

* add AWS S3 bucket module with encryption and versioning support ([e44cabf](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/e44cabf3f73321dd24ba4d5a949da6e5fdc1a9ce))
* **aws-s3-bucket:** add public access block and bucket policy support ([b2438aa](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/b2438aa42e84f7c8756ed4bb919bf48d216ec2c3))
* reorganize examples and add event notification module ([a1bcfce](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/a1bcfcebeb2fe6052e61ef3c8cdc33ec8ce02c09))

### Bug Fixes

* **aws-s3-bucket:** add dependency ordering for bucket policy ([5b59532](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/5b59532eea8433b7fa756f58bcd3c4b29213059b))
* **aws-s3-bucket:** handle versioning state transitions correctly ([24a6a3a](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/24a6a3a388bdc6b2fbe4ba375c3926cb00081e7c))
* **aws-s3-bucket:** improve CI workflow and validation logic ([aa25802](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/aa258029cd14c31e34a8caad5b31e1604041079d))
* **aws-s3-bucket:** simplify versioning status logic ([e63c0bc](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3/commit/e63c0bc89aa5182e70e1c41476e3e42d745df99c))

## [unreleased]

### 🚀 Features

- [**breaking**] Add AWS S3 bucket module with encryption and versioning support
- *(aws-s3-bucket)* Add public access block and bucket policy support
- [**breaking**] Reorganize examples and add event notification module

### 🐛 Bug Fixes

- *(aws-s3-bucket)* Improve CI workflow and validation logic
- *(aws-s3-bucket)* Handle versioning state transitions correctly
- *(aws-s3-bucket)* Simplify versioning status logic
- *(aws-s3-bucket)* Add dependency ordering for bucket policy

### 🚜 Refactor

- *(aws-s3-bucket)* Rename module and standardize output naming
- Rename folders example from with-folders to folders

### 📚 Documentation

- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- *(readme)* Update documentation with bucket policy and resources
- Update CHANGELOG.md [skip ci]
- Update repository references from terraform-aws-s3-bucket to terraform-aws-s3
- Update module source references and standardize outputs
- Update CHANGELOG.md [skip ci]

### 🎨 Styling

- *(aws-s3-bucket)* Align variable definitions for consistency
- *(bucket)* Remove extra blank line in main.tf

### 🧪 Testing

- Refactor test suite and standardize output naming

### ⚙️ Miscellaneous Tasks

- Fix AWS credentials and improve git workflow
- Update module path references from aws-s3-bucket to bucket
- Update module source references from aws-s3-bucket to bucket
