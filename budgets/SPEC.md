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
| [oci_budget_alert_rule.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/budget_alert_rule) | resource |
| [oci_budget_budget.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/budget_budget) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_budgets_configuration"></a> [budgets\_configuration](#input\_budgets\_configuration) | n/a | <pre>object({<br>    #default_compartment_id   = optional(string),<br>    default_defined_tags     = optional(map(string)),<br>    default_freeform_tags    = optional(map(string))<br>    budgets = optional(map(object({<br>      #compartment_id   = optional(string),<br>      name             = string,<br>      description      = optional(string),<br>      target           = optional(object({<br>        type   = optional(string), # Default: COMPARTMENT<br>        values = optional(list(string)) # Default: [<tenancy_ocid>]<br>      })),<br>      amount = number,<br>      schedule = optional(object({<br>        reset_period = optional(string), # Default: MONTHLY<br>        processing_period_type = optional(string) # Default: MONTH. Valid values: MONTH, SINGLE_USE.<br>        day_of_month_to_begin = optional(number), # Only applicable when processing_period_type is MONTH. Default: <current day>.<br>        single_use_start_date = optional(string), # Only applicable when processing_period_type is SINGLE_USE.<br>        single_use_end_date = optional(string) # Only applicable when processing_period_type is SINGLE_USE.<br>      })),<br>      defined_tags     = optional(map(string)),<br>      freeform_tags    = optional(map(string)),<br>      alert_rule       = optional(object({<br>        name             = optional(string)<br>        description      = optional(string)<br>        threshold_metric = optional(string), # Default: ACTUAL<br>        threshold_type   = optional(string), # Default: PERCENTAGE<br>        threshold_value  = number,<br>        recipients       = optional(string),<br>        message          = optional(string),<br>        defined_tags     = optional(map(string)),<br>        freeform_tags    = optional(map(string))<br>      }))<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | `map(any)` | `null` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"budgets"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_alert_rules"></a> [budget\_alert\_rules](#output\_budget\_alert\_rules) | The budget alert rules. |
| <a name="output_budgets"></a> [budgets](#output\_budgets) | The budgets. |
