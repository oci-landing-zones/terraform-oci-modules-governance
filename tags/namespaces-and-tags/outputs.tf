# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "tag_namespaces" {
  description = "The tag namespaces."
  value       = oci_identity_tag_namespace.these
}

output "tags" {
  description = "The tags."
  value       = oci_identity_tag.these
}

output "tag_defaults_configuration" {
  description = "Tag defaults to create after their target compartments exist."
  value = merge({ for td in local.tag_defaults : td.key => {
    tag_definition_id = td.tag_definition_id
    compartment_id    = td.compartment_id
    default_value     = td.default_value
    is_user_required  = td.is_user_required
  } }, local.cis_created_by_tag_default, local.cis_created_on_tag_default)
}
