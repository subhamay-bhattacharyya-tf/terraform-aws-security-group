// File: test/s3_bucket_sse_kms_test.go
package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestS3BucketSSEKMS tests creating an S3 bucket with SSE-KMS encryption
func TestS3BucketSSEKMS(t *testing.T) {
	t.Parallel()

	kmsKeyAlias := "SB-KMS"

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-sse-kms-%s", unique)

	tfDir := "../examples/bucket/sse-kms"

	s3Config := map[string]interface{}{
		"bucket_name":   bucketName,
		"sse_algorithm": "aws:kms",
		"kms_key_alias": kmsKeyAlias,
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"s3":     s3Config,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getS3Client(t)

	exists := bucketExists(t, client, bucketName)
	require.True(t, exists, "Expected bucket %q to exist", bucketName)

	props := fetchBucketProps(t, client, bucketName)
	require.Equal(t, "aws:kms", props.SSEAlgorithm, "Expected SSE-KMS encryption")
	require.NotEmpty(t, props.KMSKeyID, "Expected KMS key ID to be set")
}
