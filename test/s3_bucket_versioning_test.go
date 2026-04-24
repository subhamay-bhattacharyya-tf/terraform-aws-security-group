// File: test/s3_bucket_versioning_test.go
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

// TestS3BucketVersioning tests creating an S3 bucket with versioning enabled
func TestS3BucketVersioning(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-versioning-%s", unique)

	tfDir := "../examples/bucket/versioning"

	s3Config := map[string]interface{}{
		"bucket_name": bucketName,
		"versioning":  true,
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
	require.True(t, props.VersioningEnabled, "Expected versioning to be enabled")

	outputVersioning := terraform.Output(t, tfOptions, "versioning_status")
	require.Equal(t, "true", outputVersioning)
}
