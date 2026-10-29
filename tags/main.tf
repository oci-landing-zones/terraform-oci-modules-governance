# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "namespaces_and_tags" {
  source                  = "./namespaces-and-tags"
  tenancy_ocid            = var.tenancy_ocid
  tags_configuration      = var.tags_configuration
  compartments_dependency = var.compartments_dependency
  module_name             = var.module_name
}

module "defaults" {
  source                     = "./defaults"
  tenancy_ocid               = var.tenancy_ocid
  tag_defaults_configuration = module.namespaces_and_tags.tag_defaults_configuration
  compartments_dependency    = var.compartments_dependency
}

moved {
  from = oci_identity_tag_namespace.these
  to   = module.namespaces_and_tags.oci_identity_tag_namespace.these
}

moved {
  from = oci_identity_tag.these
  to   = module.namespaces_and_tags.oci_identity_tag.these
}

moved {
  from = oci_identity_tag_default.these
  to   = module.defaults.oci_identity_tag_default.these
}
