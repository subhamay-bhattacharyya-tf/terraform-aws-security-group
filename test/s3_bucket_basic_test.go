// File: test/s3_bucket_basic_test.go
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

// TestS3BucketBasic tests creating a basic S3 bucket
func TestS3BucketBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-basic-%s", unique)

	tfDir := "../examples/bucket/basic"

	s3Config := map[string]interface{}{
		"bucket_name": bucketName,
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

	outputBucketID := terraform.Output(t, tfOptions, "bucket_id")
	require.Equal(t, bucketName, outputBucketID)
}
