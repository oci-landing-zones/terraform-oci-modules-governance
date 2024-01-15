# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "cislz_tags" {
  source       = "../.."
  tenancy_ocid = var.tenancy_ocid
  tags_configuration = var.tags_configuration
  compartments_dependency = var.oci_compartments_dependency != null ? jsondecode(data.oci_objectstorage_object.compartments[0].content) : null
}