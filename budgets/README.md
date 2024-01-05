# CIS OCI Landing Zone Budgets Module

![Landing Zone logo](../landing_zone_300.png)

This module manages budgets in Oracle Cloud Infrastructure (OCI) based on a single configuration object. Budgets are used to set soft limits on your OCI spending. A budget can be associated with an alert rule for pro-actively informing about imminent budget overruns. Budgets can be set on compartments or on cost-tracking tags, which are both supported by this module. 

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for actual module usage.

- [Requirements](#requirements)
- [How to Invoke the Module](#invoke)
- [Module Functioning](#functioning)
- [Related Documentation](#related)
- [Known Issues](#issues)

## <a name="requirements">Requirements</a>
### IAM Permissions

This module requires the following OCI IAM permission:

```
Allow group <group> to manage usage-budgets in tenancy
```

**Note:** Budgets are always created in the Root compartment, regardless the compartment they target.

### Terraform Version < 1.3.x and Optional Object Type Attributes
This module relies on [Terraform Optional Object Type Attributes feature](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes), which is experimental from Terraform 0.14.x to 1.2.x. It shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes. The feature has been promoted and it is no longer experimental in Terraform 1.3.x.

**As is, this module can only be used with Terraform versions up to 1.2.x**, because it can be consumed by other modules via [OCI Resource Manager service](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/home.htm), that still does not support Terraform 1.3.x.

Upon running *terraform plan* with Terraform versions prior to 1.3.x, Terraform displays the following warning:
```
Warning: Experimental feature "module_variable_optional_attrs" is active
```

Note the warning is harmless. The code has been tested with Terraform 1.3.x and the implementation is fully compatible.

If you really want to use Terraform 1.3.x, in [providers.tf](./providers.tf):
1. Change the terraform version requirement to:
```
required_version = ">= 1.3.0"
```
2. Remove the line:
```
experiments = [module_variable_optional_attrs]
```
## <a name="invoke">How to Invoke the Module</a>

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "budgets" {
  source = "../.."
  tenancy_ocid = var.tenancy_ocid
  budgets_configuration = var.budgets_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the budgets module folder in this repository, as shown:
```
module "budgets" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance/budgets"
  tenancy_ocid = var.tenancy_ocid
  budgets_configuration = var.budgets_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance//budgets?ref=v0.1.2"
```

## <a name="functioning">Module Functioning</a>

In this module, budgets are defined using the top-level *budgets_configuration* variable. It contains a set of attributes starting with the prefix *default_* and a *budgets* attribute that defines any number of budgets. The *default_* attribute values are applied to all budgets, unless overridden at the budget level. The *budgets* attribute is a map of objects. Each object (budget) is defined as a key/value pair. The key must be unique and not be changed once defined. See the [examples](./examples/) folder for sample declarations.

The *default_* attributes are the following:

- **default_defined_tags**: (Optional) The default defined tags that are applied to all resources managed by this module. It can be overridden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: (Optional) The default freeform tags that are applied to all resources managed by this module. It can be overridden by *freeform_tags* attribute in each resource.

### Defining Budgets
- **budgets**: A map of budgets.
  - **name**: The budget name.             
  - **description**: (Optional) The budget description. It defaults to budget *name* if undefined.
  - **target**: (Optional) The budget target (aka scope). If undefined, the target is of *type* "COMPARTMENT" with *value* equals to the tenancy OCID. It is an object made of the following attributes:
    - **type**: (Optional) The target type. Valid values: "COMPARTMENT" or "TAG". Default: "COMPARTMENT". If "TAG", the value in *values* attribute *must be a **cost tracking** tag*.
    - **values**: (Optional) the target values. Although the attribute is of list data type, the Budget service currently supports only one value for a given *type*. If *type* is "COMPARTMENT", *values* should contain the target compartment OCID. If *values* is omitted, then the tenancy OCID is used as the compartment OCID. If *type* is "TAG", values must contain the cost-tracking tag in the format **"\<tag-namespace\>.\<tag-name\>.\<tag-value\>"**. For example: *"Oracle-Tags.CreatedBy.andre"*.  
  - **amount**: The budget amount in US dollars.
  - **schedule**: (Optional) The time settings when the budget applies. If undefined, the budget is set to apply on a recurring monthly basis, starting the moment when the budget is created. It is an object made of the following attributes:
    - **reset_period**: (Optional) The period the budget is reset. Only currently supported value is "MONTHLY".
    - **processing_period_type**: (Optional) The type of budget processing period. Valid values are "MONTH" or "SINGLE_USE". Default: "MONTH". "MONTH" is recurring while "SINGLE_USE" is not.
    - **day_of_month_to_begin**: (Optional) The day of the month when budget processing begins. Only applicable if *processing_period_type* is "MONTH". Default: day of budget creation.
    - **single_use_start_date**: (Optional) The date when budget processing begins. Only applicable if *processing_period_type* is "SINGLE_USE". Format must be "YYYY-MM-DD". Example: "2024-01-01".
    - **single_use_end_date**: (Optional) The date when budget processing ends. Only applicable if *processing_period_type* is "SINGLE_USE". Format must be "YYYY-MM-DD". Example: "2024-02-29".
  - **defined_tags**: (Optional) The budget defined tags. *default_defined_tags* is used if undefined.
  - **freeform_tags**: (Optional) The budget freeform tags. *default_freeform_tags* is used if undefined.
  - **alert_rule**: (Optional) The alert rule for warning recipients about specific budget conditions. It is an object made of the following attributes:
    - **name**: (Optional) The alert rule name. It defaults to "\<budget-name\>-alert-rule" if undefined.
    - **description**: (Optional) The alert rule description. It defaults to "\<budget-description\> (alert rule)" if undefined.
    - **threshold_metric**: (Optional) The budget threshold metric, representing either actual spending or forecast spending. Valid values are "ACTUAL" or "FORECAST". Default: "ACTUAL".
    - **threshold_type**: (Optional) The budget threshold type, representing either percentage spending or absolute spending.  Valid values are "PERCENTAGE" or "ABSOLUTE". Default: "PERCENTAGE".
    - **threshold_value**: The threshold value for triggering the alert. If *threshold_type* is "PERCENTAGE", the value is a percentage of the budget amount. 
    - **recipients**: The recipient email addresses for the alert rule message. Multiple recipients can be informed as comma-separated string.
    - **message**: The message that is sent to recipients when the alert is triggered.
    - **defined_tags**: (Optional) The alert rule defined tags. The budget *defined_tags* is used if undefined.
    - **freeform_tags**: (Optional) The alert rule freeform tags. The budget *freeform_tags* is used if undefined.

**Note**: If all optional attributes are omitted, then a MONTHLY recurring budget is set for the Root compartment along with an alert rule. See [minimal-config-budget](./examples/minimal-config-budget/) for an example.

### <a name="extdep">External Dependencies</a>

An optional feature, external dependencies are resources managed elsewhere that resources managed by this module may depend on. The following dependencies are supported:

- **compartments_dependency**: A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the compartment OCID. This mechanism allows for the usage of referring keys (instead of OCIDs) when defining the budget target compartments (*target* *values* attribute when *target* *type* is "COMPARTMENT"). The module replaces the keys by the OCIDs provided within *compartments_dependency* map. Contents of *compartments_dependency* is typically the output of a [Compartments module](../compartments/) client.

## <a name="related">Related Documentation</a>
- [OCI Budgets](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/budgetsoverview.htm)
- [Budgets in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/budget_budget)

## <a name="issues">Known Issues</a>
None.