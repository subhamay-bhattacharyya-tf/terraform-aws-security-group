// File: test/s3_bucket_sse_s3_test.go
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

// TestS3BucketSSES3 tests creating an S3 bucket with SSE-S3 encryption
func TestS3BucketSSES3(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-sse-s3-%s", unique)

	tfDir := "../examples/bucket/sse-s3"

	s3Config := map[string]interface{}{
		"bucket_name":   bucketName,
		"sse_algorithm": "AES256",
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
	require.Equal(t, "AES256", props.SSEAlgorithm, "Expected SSE-S3 encryption")
}
