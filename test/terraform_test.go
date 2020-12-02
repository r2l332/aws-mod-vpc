package vpc

import (
	"fmt"
	"os"
	"testing"

	awssdk "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testTerraformApply(t *testing.T, backendBucket, backendTable string) {

	dir, err := files.CopyTerraformFolderToTemp("./..", "vpc")
	if err != nil {
		t.Fatal(err)
	}
	logger.Logf(t, "Terraform directory: %s", dir)

	name := "eks"
	
	backendConfig := map[string]interface{}{
		"bucket":         backendBucket,
		"region":         region,
		"key":            fmt.Sprintf("infrastructure/vpc/ci/%s/terraform.tfstate", identifier),
		"dynamodb_table": backendTable,
		"role_arn":       devRoleArn,
	}

	terraformOptions := &terraform.Options{
		Vars: map[string]interface{}{
			"region": region,
			"name":   name,
			"vpc_cidr": "10.0.0.0/16",
			"pub_subnet_cidrs": []string{},
			"priv_subnet_cidrs": []string{},
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION":    region,
			"AWS_PROFILE":           os.Getenv("AWS_PROFILE"),
			"PATH":                  os.Getenv("PATH"),
			"AWS_SDK_LOAD_CONFIG":   os.Getenv("AWS_SDK_LOAD_CONFIG"),
			"AWS_CONFIG_FILE":       os.Getenv("AWS_CONFIG_FILE"),
			"AWS_ACCESS_KEY_ID":     os.Getenv("AWS_ACCESS_KEY_ID"),
			"AWS_SECRET_ACCESS_KEY": os.Getenv("AWS_SECRET_ACCESS_KEY"),
			"AWS_SESSION_TOKEN":     os.Getenv("AWS_SESSION_TOKEN"),
		},
		BackendConfig: backendConfig,
		TerraformDir:  "../envs",
		NoColor:       os.Getenv("TERRAFORM_NO_COLOUR") == "true",
	}

	terraform.Init(t, terraformOptions)

	defer terraform.Destroy(t, terraformOptions)

	terraform.Apply(t, terraformOptions)

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	pubSubnetId := terraform.OutputList(t, terraformOptions, "public_subnet")
	privSubnetId := terraform.OutputList(t, terraformOptions, "private_subnet")
	// routeTableId 	:= terraform.Output(t, terraformOptions, "route_table_ids")
	
	assert.NotNil(t, privSubnetId)
	assert.NotNil(t, pubSubnetId)
	assert.NotNil(t, vpcId)
	
	vpcSvc := ec2.New(getDevAccountSession())

	vpcInput := &ec2.DescribeVpcsInput{
		VpcIds: []*string{awssdk.String(vpcId)},
	}
	getVpc, err := vpcSvc.DescribeVpcs(vpcInput)
	if err != nil {
		fmt.Println(err)
	}

	vpCreated := false
	for _, vpc := range getVpc.Vpcs {
		if *vpc.CidrBlock == "10.0.0.0/16" {
			vpCreated = true
		}
	}

	assert.True(t, vpCreated)

	pubSubNetInput := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name:   awssdk.String("subnet-id"),
				Values: []*string{awssdk.String(pubSubnetId[0])},
			},
		},
	}

	pubSubNetInput1 := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name:   awssdk.String("subnet-id"),
				Values: []*string{awssdk.String(pubSubnetId[1])},
			},
		},
	}

	pubSubNetInput2 := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name:   awssdk.String("subnet-id"),
				Values: []*string{awssdk.String(pubSubnetId[2])},
			},
		},
	}

	getPubSub, err := vpcSvc.DescribeSubnets(pubSubNetInput)
	getPubSub1, err := vpcSvc.DescribeSubnets(pubSubNetInput1)
	getPubSub2, err := vpcSvc.DescribeSubnets(pubSubNetInput2)

	psub := false
	for _, snet := range getPubSub.Subnets {
		if *snet.SubnetId == pubSubnetId[0] {
			psub = true
		}
	}
	assert.True(t, psub)
	psub1 := false
	for _, snet := range getPubSub1.Subnets {
		if *snet.SubnetId == pubSubnetId[1] {
			psub1 = true
		}
	}
	assert.True(t, psub1)
	psub2 := false
	for _, snet := range getPubSub2.Subnets {
		if *snet.SubnetId == pubSubnetId[2] {
			psub2 = true
		}
	}
	assert.True(t, psub2)

	privSubNetInput0 := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name:   awssdk.String("subnet-id"),
				Values: []*string{awssdk.String(privSubnetId[0])},
			},
		},
	}

	privSubNetInput1 := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name:   awssdk.String("subnet-id"),
				Values: []*string{awssdk.String(privSubnetId[1])},
			},
		},
	}

	privSubNetInput2 := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name:   awssdk.String("subnet-id"),
				Values: []*string{awssdk.String(privSubnetId[2])},
			},
		},
	}

	getPrivSub0, err := vpcSvc.DescribeSubnets(privSubNetInput0)
	getPrivSub1, err := vpcSvc.DescribeSubnets(privSubNetInput1)
	getPrivSub2, err := vpcSvc.DescribeSubnets(privSubNetInput2)

	priv0 := false
	for _, snet := range getPrivSub0.Subnets {
		if *snet.SubnetId == privSubnetId[0] {
			priv0 = true
		}
	}
	assert.True(t, priv0)
	priv1 := false
	for _, snet := range getPrivSub1.Subnets {
		if *snet.SubnetId == privSubnetId[1] {
			priv1 = true
		}
	}
	assert.True(t, priv1)
	priv2 := false
	for _, snet := range getPrivSub2.Subnets {
		if *snet.SubnetId == privSubnetId[2] {
			priv2 = true
		}
	}
	assert.True(t, priv2)
}
