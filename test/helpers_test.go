// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"github.com/stretchr/testify/require"
)

func getEC2Client(t *testing.T) *ec2.Client {
	t.Helper()

	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-east-1"
	}

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
	require.NoError(t, err, "Failed to load AWS config")

	return ec2.NewFromConfig(cfg)
}

func describeSecurityGroup(t *testing.T, client *ec2.Client, groupID string) *types.SecurityGroup {
	t.Helper()

	out, err := client.DescribeSecurityGroups(context.TODO(), &ec2.DescribeSecurityGroupsInput{
		GroupIds: []string{groupID},
	})
	require.NoError(t, err, "DescribeSecurityGroups failed for %s", groupID)
	require.Len(t, out.SecurityGroups, 1, "Expected exactly one security group for %s", groupID)
	return &out.SecurityGroups[0]
}

func describeIngressRule(t *testing.T, client *ec2.Client, ruleID string) *types.SecurityGroupRule {
	t.Helper()
	return describeRule(t, client, ruleID, false)
}

func describeEgressRule(t *testing.T, client *ec2.Client, ruleID string) *types.SecurityGroupRule {
	t.Helper()
	return describeRule(t, client, ruleID, true)
}

func describeRule(t *testing.T, client *ec2.Client, ruleID string, expectEgress bool) *types.SecurityGroupRule {
	t.Helper()

	out, err := client.DescribeSecurityGroupRules(context.TODO(), &ec2.DescribeSecurityGroupRulesInput{
		SecurityGroupRuleIds: []string{ruleID},
	})
	require.NoError(t, err, "DescribeSecurityGroupRules failed for %s", ruleID)
	require.Len(t, out.SecurityGroupRules, 1, "Expected exactly one rule for %s", ruleID)

	rule := out.SecurityGroupRules[0]
	if rule.IsEgress != nil {
		require.Equal(t, expectEgress, *rule.IsEgress, "rule %s direction mismatch", ruleID)
	}
	return &rule
}

func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

