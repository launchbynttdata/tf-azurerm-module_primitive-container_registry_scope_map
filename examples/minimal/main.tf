// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", each.value.region))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  use_azure_region_abbr   = true
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = module.resource_names["rg"][var.resource_names_strategy]
  location = var.resource_names_map["rg"].region
  tags     = local.tags
}

module "container_registry" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/container_registry/azurerm"
  version = "~> 2.0"

  container_registry_name = module.resource_names["acr"].minimal_random_suffix_without_any_separators
  resource_group_name     = module.resource_group.name
  location                = var.resource_names_map["acr"].region
  admin_enabled           = false

  depends_on = [module.resource_group]

  tags = local.tags
}

module "scope_map" {
  source = "../.."

  name                    = module.resource_names["scope_map"].minimal_random_suffix_without_any_separators
  resource_group_name     = module.resource_group.name
  container_registry_name = module.resource_names["acr"].minimal_random_suffix_without_any_separators
  actions                 = var.actions

  depends_on = [module.resource_group, module.container_registry]
}
