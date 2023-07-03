# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "tag_namespaces" {
  description = "The tag namespaces."
  value = var.enable_output ? oci_identity_tag_namespace.these : null
}

output "tags" {
  description = "The tags."
  value = var.enable_output ? oci_identity_tag.these : null
}

output "tag_defaults" {
  description = "The tag defaults."
  value = var.enable_output ? oci_identity_tag_default.these : null
}