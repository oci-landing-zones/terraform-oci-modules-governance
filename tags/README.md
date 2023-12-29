# CIS OCI Landing Zone IAM Tags Module

![Landing Zone logo](../landing_zone_300.png)

This module manages tag namespaces, defined tags and tag defaults resources in Oracle Cloud Infrastructure. Tags are metadata added to resources to help in tenancy's organization, governance and security.

Additionally, following CIS (Center for Internet Security) OCI Foundations Benchmark recommendation, it provides an easy way to enable a tag namespace to track who creates resources and the creation time of the resources. This namespace is created upon request, and only if a potentially pre-existing tag namespace named "Oracle-Tags" with "CreatedBy" and "CreatedOn" tags is not available in the tenancy.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for module usage with actual input data.

- [Requirements](#requirements)
- [How to Invoke the Module](#invoke)
- [Module Functioning](#functioning)
- [Related Documentation](#related)
- [Known Issues](#issues)

## <a name="requirements">Requirements</a>
### IAM Permissions

This module requires the following OCI IAM permissions:

#### For Tag Namespaces
Permissions must be granted on the compartments where the tag namespaces are defined. Within *tags_configuration*, these compartments are either defined for each tag namespace (using attribute *compartment_id*), or at the *tags_configuration* level (using attribute *default_compartment_id*), or at the tenancy level (using variable *tenancy_ocid*).
```
Allow group <group> to manage tag-namespaces in compartment <TAG-NAMESPACE-COMPARTMENT-OCID>
```
If *\<TAG-NAMESPACE-COMPARTMENT-OCID\>* is the root compartment, the permission becomes:
```
Allow group <group> to manage tag-namespaces in tenancy
```
#### For Tag Defaults
Permissions must be granted on the compartments where the tag defaults are applied. Within *tags*' *tag_defaults* attribute, these compartments are defined by *compartment_ocids* attribute.
```
Allow group <group> to manage tag-defaults in compartment <COMPARTMENT-OCID>
Allow group <group> to inspect tag-namespaces in tenancy
```
If *\<COMPARTMENT-OCID\>* is the root compartment (tenancy level), the permissions become:
```
Allow group <group> to manage tag-defaults in tenancy
Allow group <group> to inspect tag-namespaces in tenancy
```
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
module "tags" {
  source = "../.."
  tenancy_ocid = var.tenancy_ocid
  tags_configuration = var.tags_configuration

}
```

For invoking the module remotely, set the module *source* attribute to the tags module folder in this repository, as shown:
```
module "tags" {
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules.git//tags"
  tenancy_ocid = var.tenancy_ocid
  tags_configuration = var.tags_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules.git//tags?ref=v0.1.0"
```

## <a name="functioning">Module Functioning</a>

The module uses a single variable (*tags_configuration*) for configuring an arbitrary number of tag namespaces, their defined tags and any tag defaults to apply on target compartments. It contains a set of attributes starting with the prefix *default_* and a *namespaces* attribute that defines any number of tag namespaces and tags. The *default_* attribute values are applied to all namespaces and tags, unless overridden at the namespace/tag level. The *namespaces* attribute is a map of objects. Each object (tag namespace) is defined as a key/value pair. The key must be unique and not be changed once defined. See the [examples](./examples/) folder for sample declarations. Additionally, the module supports the easy creation of CIS recommended tags for identifying resource creators and the time when resources are created through the *cislz_namespace_name* attribute.

The *default_* attributes are the following:

- **default_compartment_id**: (Optional) The default compartment id for all resources managed by this module. It can be overridden by *compartment_id* attribute in each resource. It defaults to the *tenancy_ocid* variable if undefined.
- **default_defined_tags**: (Optional) The default defined tags that are applied to all resources managed by this module. It can be overridden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: (Optional) The default freeform tags that are applied to all resources managed by this module. It can be overridden by *freeform_tags* attribute in each resource.

CIS recommended tags:

- **cislz_namespace_name**: when defined, the module creates a tag namespace along with *CreatedBy* and *CreatedOn* defined tags, but only if the *Oracle-Tags* namespace is not available in the tenancy. The *Oracle-Tag* namespace already defines *CreatedBy* and *CreatedOn* defined tags.

Defining tag namespaces and tags:

- **namespaces**: A map of tag namespaces.
  - **name**: The tag namespace name.             
  - **description**: (Optional) The tag namespace description. It defaults to tag namespace *name* if undefined.
  - **compartment_id**: (Optional) The compartment id for the tag namespace. It defaults to *default_compartment_id* if undefined.
  - **is_retired**: (Optional) Whether the tag namespace is retired. Default: false.
  - **defined_tags**: (Optional) The tag namespace defined tags. It defaults to *default_defined_tags* if undefined.
  - **freeform_tags**: (Optional) The tag namespace freeform tags. It defaults to *default_freeform_tags* if undefined.
  - **tags**: (Optional) The defined tags. It is a map of objects (tags) for this tag namespace, where each object is made of the following attributes:
    - **name**: The tag name.
    - **description**: (Optional) The tag description. It defaults to tag *name* if undefined.
    - **is_cost_tracking**: (Optional) Whether the tag is a cost tracking tag. Default: false.
    - **is_retired**: (Optional) Whether the tag is retired. Default: false.
    - **valid_values**: (Optional) A list of valid values for the tag. If defined, any value assigned to the tag is checked against the list. 
    - **tag_defaults**: (Optional) The tag default values to apply to the list of provided compartments.
      - **compartment_ids**: The list of compartments to apply the tag defaults.
      - **default_value**: The default value.
      - **is_user_required**: (Optional) When true, *default_value* is ignored and user must provide a value when creating a resource in the target compartment. When false or absent, *default_value* is applied. Default: false.
    - **defined_tags**: (Optional) The tag defined tags. It defaults to tag namespace *defined_tags* if undefined.
    - **freeform_tags**: (Optional) The tag freeform tags. It defaults to tag namespace *freeform_tags* if undefined.  

### <a name="extdep">External Dependencies</a>

An optional feature, external dependencies are resources managed elsewhere that resources managed by this module may depend on. The following dependencies are supported:

- **compartments_dependency**: A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the compartment OCID. This mechanism allows for the usage of referring keys (instead of OCIDs) when defining compartments for tag namespaces and tag defaults targets. The module replaces the keys by the OCIDs provided within *compartments_dependency* map. Contents of *compartments_dependency* is typically the output of a [Compartments module](../compartments/) client.

## Related Documentation
- [OCI Tagging Documentation](https://docs.oracle.com/en-us/iaas/Content/Tagging/home.htm)
- [Tags in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/4.112.0/docs/resources/identity_tag)

## Known Issues
None.
