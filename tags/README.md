# CIS OCI Landing Zone IAM Tags Module

![Landing Zone logo](../landing_zone_300.png)

This module manages tag namespaces, defined tags and tag defaults resources in Oracle Cloud Infrastructure. Tags are metadata added to resources to help in tenancy's organization, governance and security.

Additionaly, following CIS (Center for Internet Security) OCI Foundations Benchmark recommendation, it provides an easy way to enable a tag namespace to track who creates resources and the creation time of the resources. This namespace is created upon request, and only if a potentially pre-existing tag namespace named "Oracle-Tags" with "CreatedBy" and "CreatedOn" tags is not available in the tenancy.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

The module uses a single variable (*tags_configuration*) for configuring an arbitrary number of tag namespaces, their defined tags and any tag defaults to apply on target compartments.

Check the [examples](./examples/) folder for module usage with actual input data.

## Requirements
### IAM Permissions

This module requires the following OCI IAM permissions:

#### For Tag Namespaces
Permissions must be granted on the compartments where the namespaces are defined. Within *tags_configuration*, these compartments are either defined for each tag namespace (using attribute *compartment_ocid*), or at the *tags_configuration* level (using attribute *default_compartment_ocid*), or at the tenancy level (using variable *tenancy_ocid*).
```
Allow group <group> to manage tag-namespaces in compartment <tag_namespace_compartment_ocid>
```
If \<tag_namespace_compartment_ocid\> is the root compartment, the permission becomes:
```
Allow group <group> to manage tag-namespaces in tenancy
```
#### For Tag Defaults
Permissions must be granted on the compartments where the tag defaults are applied. Within *tags*' *tag_defaults* attribute, these compartments are defined by *compartment_ocids* attribute.
```
Allow group <group> to manage tag-defaults in compartment <compartment_ocids>
Allow group <group> to inspect tag-namespaces in tenancy
```
If \<compartment_ocids\> is the root compartment (tenancy level), the permissions become:
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

## How to Invoke the Module

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

## Related Documentation
- [OCI Tagging Documentation](https://docs.oracle.com/en-us/iaas/Content/Tagging/home.htm)
- [Tags in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/4.112.0/docs/resources/identity_tag)

## Known Issues
None.
