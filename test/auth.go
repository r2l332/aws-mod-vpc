package vpc

import (
	"flag"
	"os"
	"testing"
	"math/rand"
	"time"
	"strings"

	"github.com/aws/aws-sdk-go/aws/session"
	awst "github.com/gruntwork-io/terratest/modules/aws"
)

var region string
var identifier string
var devRoleArn string

func TestMain(m *testing.M) {
	flag.StringVar(&region, "region", "eu-west-1", "AWS region that everything should run in (optional)")
	flag.StringVar(&identifier, "identifier", "", "Unique identifier for this test (optional)")
	flag.StringVar(&devRoleArn, "devRoleArn", "", "Role ARN to use when accessing the dev AWS account (optional)")

	// Terraform variables
	flag.Parse()

	if testing.Short() {
		return
	}

	if identifier == "" || identifier == "null" {
		// Lazily generate the default identifier to avoid problems of using user.Current within a Docker container
		rand.Seed(time.Now().UnixNano())
		chars := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
    					"abcdefghijklmnopqrstuvwxyz" +
						"0123456789")
		length := 8
		var b strings.Builder
		for i := 0; i < length; i++ {
			b.WriteRune(chars[rand.Intn(len(chars))])
		}
		identifier = b.String()
	}

	os.Exit(m.Run())
}

func Test_Terraform(t *testing.T) {
	bucket, table := findTerraformBackend(t)

	if !t.Failed() {
		t.Run("TestTerraform", func(t *testing.T) {
			testTerraformApply(t, bucket, table)
		})
	}
}

func findTerraformBackend(t *testing.T) (string, string) {
	var bucket string
	var table string
	bucket = "eks-module-terraform-tfstate"
	table  = "terraform-state-lock"
	return bucket, table
}

func getDevAccountSession() *session.Session {
	if devRoleArn == "" {
		// No dev role, so we should default credentials
		return session.Must(awst.NewAuthenticatedSession(region))
	}

	return session.Must(awst.NewAuthenticatedSessionFromRole(region, devRoleArn))
}
