package testimpl

import (
	"context"
	"log"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/containerregistry/armcontainerregistry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")

	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		log.Fatalf("failed to obtain a credential: %v", err)
	}

	clientFactory, err := armcontainerregistry.NewClientFactory(subscriptionId, cred, nil)
	if err != nil {
		log.Fatalf("failed to create client factory: %v", err)
	}

	scopeMapsClient := clientFactory.NewScopeMapsClient()

	rgName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	registryName := terraform.Output(t, ctx.TerratestTerraformOptions(), "container_registry_name")
	scopeMapName := terraform.Output(t, ctx.TerratestTerraformOptions(), "scope_map_name")

	t.Run("ScopeMapWasCreated", func(t *testing.T) {
		resp, err := scopeMapsClient.Get(context.TODO(), rgName, registryName, scopeMapName, nil)

		if err != nil {
			log.Fatalf("failed to get scope map: %v", err)
		}
		assert.NotNilf(t, resp.ScopeMap, "Expected Scope Map to be created")
	})
}
