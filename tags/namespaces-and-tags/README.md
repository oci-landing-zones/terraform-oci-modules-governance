# Tag Namespaces and Tags

This module creates OCI tag namespaces and tag definitions. It also discovers the Oracle-Tags namespace and selects the optional CIS CreatedBy and CreatedOn tags using the same behavior as the [Tags module](../).

Use the existing `tags_configuration` input, including nested `tag_defaults`, to define the desired tags. This module exports those defaults as `tag_defaults_configuration`; it does not create default resources. Pass the exported map to the [Tag Defaults module](../defaults/) after the target compartments exist.

```hcl
module "namespaces_and_tags" {
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags/namespaces-and-tags?ref=v0.2.0"
  tenancy_ocid            = var.tenancy_ocid
  tags_configuration      = var.tags_configuration
  compartments_dependency = var.compartments_dependency
}
```

When new compartments use these tags, create the namespaces in the tenancy or an existing compartment. The namespace and tag IAM permissions are documented in the [Tags module requirements](../README.md#requirements).

Terraform 1.3.0 or later is required. See [SPEC.md](./SPEC.md) for inputs, resources and outputs.
