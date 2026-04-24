// File: test/s3_bucket_folders_test.go
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

// TestS3BucketWithFolders tests creating an S3 bucket with folder structure
func TestS3BucketWithFolders(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("tt-s3-folders-%s", unique)

	tfDir := "../examples/bucket/folders"

	s3Config := map[string]interface{}{
		"bucket_name": bucketName,
		"bucket_keys": []string{"raw-data/csv", "raw-data/json", "processed"},
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

	folders := listBucketObjects(t, client, bucketName)
	require.Contains(t, folders, "raw-data/csv/")
	require.Contains(t, folders, "raw-data/json/")
	require.Contains(t, folders, "processed/")
}
