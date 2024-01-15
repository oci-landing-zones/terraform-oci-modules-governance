# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "home_region" {}

variable "tags_configuration" {
  type = object({
    default_compartment_id   = string,
    default_defined_tags     = optional(map(string)),
    default_freeform_tags    = optional(map(string))
    cis_namespace_name       = optional(string),
    namespaces = optional(map(object({
      name             = string,
      description      = optional(string),
      compartment_id   = optional(string),
      is_retired       = optional(bool),
      defined_tags     = optional(map(string)),
      freeform_tags    = optional(map(string))
      tags = optional(map(object({
        name             = string,
        description      = optional(string),
        is_cost_tracking = optional(bool),
        is_retired       = optional(bool),
        valid_values     = optional(list(string)),
        tag_defaults     = optional(map(object({
          compartment_ids = list(string),
          default_value = string,
          is_user_required = optional(bool)
        })))
        defined_tags        = optional(map(string)),
        freeform_tags       = optional(map(string)),
      })))  
    })))
  })
  default = null
} 

variable "oci_shared_config_bucket_name" {
  type = string
  default = null
}
variable "oci_compartments_dependency" {
  type = string
  default = null
}