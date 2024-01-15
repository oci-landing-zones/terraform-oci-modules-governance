## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | < 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_tag.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag) | resource |
| [oci_identity_tag_default.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default) | resource |
| [oci_identity_tag_namespace.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_namespace) | resource |
| [oci_identity_tag.default_created_by](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tag) | data source |
| [oci_identity_tag.default_created_on](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tag) | data source |
| [oci_identity_tag_namespaces.oracle_default](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tag_namespaces) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | `map(any)` | `null` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"tags"` | no |
| <a name="input_tags_configuration"></a> [tags\_configuration](#input\_tags\_configuration) | n/a | <pre>object({<br>    default_compartment_id   = string,<br>    default_defined_tags     = optional(map(string)),<br>    default_freeform_tags    = optional(map(string))<br>    cis_namespace_name       = optional(string),<br>    namespaces = optional(map(object({<br>      name             = string,<br>      description      = optional(string),<br>      compartment_id   = optional(string),<br>      is_retired       = optional(bool),<br>      defined_tags     = optional(map(string)),<br>      freeform_tags    = optional(map(string))<br>      tags = optional(map(object({<br>        name             = string,<br>        description      = optional(string),<br>        is_cost_tracking = optional(bool),<br>        is_retired       = optional(bool),<br>        valid_values     = optional(list(string)),<br>        tag_defaults     = optional(map(object({<br>          compartment_ids = list(string),<br>          default_value = string,<br>          is_user_required = optional(bool)<br>        })))<br>        defined_tags        = optional(map(string)),<br>        freeform_tags       = optional(map(string)),<br>      })))  <br>    })))<br>  })</pre> | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The tenancy ocid, used to search on tag namespaces. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tag_defaults"></a> [tag\_defaults](#output\_tag\_defaults) | The tag defaults. |
| <a name="output_tag_namespaces"></a> [tag\_namespaces](#output\_tag\_namespaces) | The tag namespaces. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags. |
