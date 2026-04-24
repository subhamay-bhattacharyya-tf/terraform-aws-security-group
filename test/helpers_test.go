// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/stretchr/testify/require"
)

type S3BucketProps struct {
	Name              string
	VersioningEnabled bool
	SSEAlgorithm      string
	KMSKeyID          string
}

func getS3Client(t *testing.T) *s3.Client {
	t.Helper()

	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-east-1"
	}

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
	require.NoError(t, err, "Failed to load AWS config")

	return s3.NewFromConfig(cfg)
}

func bucketExists(t *testing.T, client *s3.Client, bucketName string) bool {
	t.Helper()

	_, err := client.HeadBucket(context.TODO(), &s3.HeadBucketInput{
		Bucket: &bucketName,
	})

	return err == nil
}

func fetchBucketProps(t *testing.T, client *s3.Client, bucketName string) S3BucketProps {
	t.Helper()

	props := S3BucketProps{Name: bucketName}

	// Check versioning
	versioningOutput, err := client.GetBucketVersioning(context.TODO(), &s3.GetBucketVersioningInput{
		Bucket: &bucketName,
	})
	require.NoError(t, err, "Failed to get bucket versioning")
	props.VersioningEnabled = versioningOutput.Status == types.BucketVersioningStatusEnabled

	// Check encryption
	encryptionOutput, err := client.GetBucketEncryption(context.TODO(), &s3.GetBucketEncryptionInput{
		Bucket: &bucketName,
	})
	if err == nil && len(encryptionOutput.ServerSideEncryptionConfiguration.Rules) > 0 {
		rule := encryptionOutput.ServerSideEncryptionConfiguration.Rules[0]
		if rule.ApplyServerSideEncryptionByDefault != nil {
			props.SSEAlgorithm = string(rule.ApplyServerSideEncryptionByDefault.SSEAlgorithm)
			if rule.ApplyServerSideEncryptionByDefault.KMSMasterKeyID != nil {
				props.KMSKeyID = *rule.ApplyServerSideEncryptionByDefault.KMSMasterKeyID
			}
		}
	}

	return props
}

func listBucketObjects(t *testing.T, client *s3.Client, bucketName string) []string {
	t.Helper()

	output, err := client.ListObjectsV2(context.TODO(), &s3.ListObjectsV2Input{
		Bucket: &bucketName,
	})
	require.NoError(t, err, "Failed to list bucket objects")

	var keys []string
	for _, obj := range output.Contents {
		if obj.Key != nil {
			keys = append(keys, *obj.Key)
		}
	}
	return keys
}

func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

func stringPtr(s string) *string {
	return &s
}
