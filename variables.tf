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

variable "name" {
  description = "Specifies the name of the scope map. Changing this forces a new resource to be created. This field only allows alphanumeric characters."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.name))
    error_message = "Name must only contain alphanumeric characters."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry token. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "container_registry_name" {
  description = "The name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "actions" {
  description = "A list of actions to attach to the scope map. Actions are comprised of <resource_type>/<resource_name>/<action>, where <resource_type> is e.g 'repositories', <resource_name> is either the name or a wildcard, and <action> is one of 'content/delete', 'content/read', 'content/write', 'metadata/read', 'metadata/write'."
  type        = list(string)
  nullable    = false

  validation {
    condition     = alltrue([for action in var.actions : can(regex("(content/(delete|read|write)|metadata/(read|write))$", action))])
    error_message = "All entries must end with one of 'content/delete', 'content/read', 'content/write', 'metadata/read', 'metadata/write'"
  }
}

variable "description" {
  description = "The description of the Container Registry Scope Map."
  type        = string
  nullable    = true
  default     = null
}
