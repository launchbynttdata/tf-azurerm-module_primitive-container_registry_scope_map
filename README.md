# tf-azurerm-module_primitive-container_registry_scope_map

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

A scope map to bind a set of permissions to a container registry token. A few special considerations must be taken when utilizing this resource:

- The name can only contain alphanumeric characters (no separators)
- Actions are provided in the format \<resource_type\>/\<resource_name\>/\<action\>, where:
  - \<resource_type\> denotes the type of resource in question, a typical value for this is `repositories`
  - \<resource_name\> is the name of the resource to which permissions will be provided. This should be the name of a repository, including a wildcard. If a wildcard is used, additional rules about the placement of the wildcard apply, see [the ACR documentation](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-token-based-repository-permissions#how-to-use-scope-maps-to-define-and-assign-permissions-for-multiple-repositories) for specifics.
  - \<action\> is the permission to grant, and must be one of the following:
    - content/delete
    - content/read
    - content/write
    - metadata/read
    - metadata/write

## Local Development and Testing

To set yourself up for local development and testing activities, ensure you have the following software available on your PATH:

- make
- git (ensure your user.name and user.email are configured)
- [git-repo](https://gerrit.googlesource.com/git-repo#install)
- [`asdf`](https://asdf-vm.com) or [`mise`](https://mise.jdx.dev/)
- python3 (for pre-commit hooks)

You will also need to authenticate to the Cloud Provider. Terraform will use the default credential resolution mechanism, so ensure you are signed on through the CLI.

Clone this repository to your machine and issue the following command:

```
make configure
```

This will synchronize supporting repositories into this directory and expose additional targets.

To perform linting actions against the Terraform module and Terratests, issue the following command:

```
make lint
```

To provision cloud resources and perform tests against them, issue the following command:

```
make test
```

Note that `make test` causes the creation of some ignored files on your filesystem. This behavior is expected and we want to exclude any state or lockfiles from being pushed to the repository.

These two commands will be utilized in the pipeline and if you cannot run them successfully locally, you are unlikely to see a different result in the pipeline.

For convenience, a target exists that will execute both `make lint` and `make test` for you in sequence. Issue the following command to perform a holistic lint and test:

```
make check
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry_scope_map.scope_map](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_scope_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the scope map. Changing this forces a new resource to be created. This field only allows alphanumeric characters. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Container Registry token. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_container_registry_name"></a> [container\_registry\_name](#input\_container\_registry\_name) | The name of the Container Registry. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_actions"></a> [actions](#input\_actions) | A list of actions to attach to the scope map. Actions are comprised of <resource\_type>/<resource\_name>/<action>, where <resource\_type> is e.g 'repositories', <resource\_name> is either the name or a wildcard, and <action> is one of 'content/delete', 'content/read', 'content/write', 'metadata/read', 'metadata/write'. | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the Container Registry Scope Map. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Container Registry scope map. |
<!-- END_TF_DOCS -->
