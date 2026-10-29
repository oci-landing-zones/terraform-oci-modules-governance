# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_identity_tag_default" "these" {
  for_each          = var.tag_defaults_configuration
  compartment_id    = length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : (upper(each.value.compartment_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[each.value.compartment_id].id)
  tag_definition_id = each.value.tag_definition_id
  value             = each.value.default_value
  is_required       = each.value.is_user_required
}
