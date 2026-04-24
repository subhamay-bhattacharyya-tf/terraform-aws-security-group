// File: test/security_group_basic_test.go
package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestSecurityGroupBasic applies examples/basic against a real VPC, asserts
// that the security group and its ingress/egress rules exist in AWS and that
// the module outputs match, then destroys everything.
//
// Required env vars:
//   AWS_REGION  - AWS region (defaults to us-east-1 via helpers when unset)
//   AWS_VPC_ID  - VPC ID in which to create the security group
func TestSecurityGroupBasic(t *testing.T) {
	t.Parallel()

	region := mustEnv(t, "AWS_REGION")
	vpcID := mustEnv(t, "AWS_VPC_ID")

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
		Vars: map[string]interface{}{
			"region": region,
			"vpc_id": vpcID,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	sgIDs := terraform.OutputMap(t, tfOptions, "security_group_ids")
	require.Contains(t, sgIDs, "web", "security_group_ids output missing 'web' key")
	webSGID := sgIDs["web"]
	require.NotEmpty(t, webSGID, "web security group ID is empty")

	ingressIDs := terraform.OutputMap(t, tfOptions, "ingress_rule_ids")
	egressIDs := terraform.OutputMap(t, tfOptions, "egress_rule_ids")
	require.Contains(t, ingressIDs, "web_https_ingress")
	require.Contains(t, ingressIDs, "web_http_ingress")
	require.Contains(t, egressIDs, "web_all_egress")

	client := getEC2Client(t)

	sg := describeSecurityGroup(t, client, webSGID)
	assert.Equal(t, "web-sg", stringValue(sg.GroupName), "GroupName mismatch")
	assert.Equal(t, vpcID, stringValue(sg.VpcId), "VpcId mismatch")

	httpsRule := describeIngressRule(t, client, ingressIDs["web_https_ingress"])
	assert.Equal(t, int32(443), int32Value(httpsRule.FromPort))
	assert.Equal(t, int32(443), int32Value(httpsRule.ToPort))
	assert.Equal(t, "tcp", stringValue(httpsRule.IpProtocol))
	assert.Equal(t, "0.0.0.0/0", stringValue(httpsRule.CidrIpv4))

	httpRule := describeIngressRule(t, client, ingressIDs["web_http_ingress"])
	assert.Equal(t, int32(80), int32Value(httpRule.FromPort))
	assert.Equal(t, int32(80), int32Value(httpRule.ToPort))

	egressRule := describeEgressRule(t, client, egressIDs["web_all_egress"])
	assert.Equal(t, "-1", stringValue(egressRule.IpProtocol))
	assert.Equal(t, "0.0.0.0/0", stringValue(egressRule.CidrIpv4))
}

func stringValue(p *string) string {
	if p == nil {
		return ""
	}
	return *p
}

func int32Value(p *int32) int32 {
	if p == nil {
		return 0
	}
	return *p
}
