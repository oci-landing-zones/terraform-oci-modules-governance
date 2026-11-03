# Tag Defaults

This module creates OCI tag defaults from a `tag_defaults_configuration` map, typically exported by the [Tag Namespaces and Tags module](../namespaces-and-tags/). Each entry contains a tag definition ID, target compartment reference, default value and optional user-required setting.

```hcl
module "tag_defaults" {
  source                     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags/defaults?ref=v0.2.0"
  tenancy_ocid               = var.tenancy_ocid
  tag_defaults_configuration = module.namespaces_and_tags.tag_defaults_configuration
  compartments_dependency    = var.compartments_dependency
}
```

Targets may be literal compartment OCIDs, the reserved `TENANCY-ROOT` reference, or keys resolved through `compartments_dependency`. If the same configuration creates those compartments, pass the created compartments map instead of an external-only map.

Defaults apply to resources created afterward. Downstream resource creation must wait for the defaults and their propagation; this module does not add a propagation delay. The tag-default IAM permissions are documented in the [Tags module requirements](../README.md#requirements).

Terraform 1.3.0 or later is required. See [SPEC.md](./SPEC.md) for inputs, resources and outputs.
