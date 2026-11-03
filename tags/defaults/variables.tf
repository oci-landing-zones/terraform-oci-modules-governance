# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The tenancy OCID used for TENANCY-ROOT compartment references."
  type        = string
}

variable "tag_defaults_configuration" {
  description = "Tag defaults keyed by their stable resource keys, as exported by the namespaces-and-tags module."
  type = map(object({
    tag_definition_id = string
    compartment_id    = string
    default_value     = string
    is_user_required  = optional(bool, false)
  }))
  default = {}
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type."
  type        = map(any)
  default     = null
}
