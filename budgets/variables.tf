# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}

variable "budgets_configuration" {
  type = object({
    #default_compartment_id   = optional(string),
    default_defined_tags     = optional(map(string)),
    default_freeform_tags    = optional(map(string))
    budgets = optional(map(object({
      #compartment_id   = optional(string),
      name             = string,
      description      = optional(string),
      target           = optional(object({
        type   = optional(string), # Default: COMPARTMENT
        values = optional(list(string)) # Default: [<tenancy_ocid>]
      })),
      amount = number,
      schedule = optional(object({
        reset_period = optional(string), # Default: MONTHLY
        processing_period_type = optional(string) # Default: MONTH. Valid values: MONTH, SINGLE_USE.
        day_of_month_to_begin = optional(number), # Only applicable when processing_period_type is MONTH. Default: <current day>.
        single_use_start_date = optional(string), # Only applicable when processing_period_type is SINGLE_USE.
        single_use_end_date = optional(string) # Only applicable when processing_period_type is SINGLE_USE.
      })),
      defined_tags     = optional(map(string)),
      freeform_tags    = optional(map(string)),
      alert_rule       = optional(object({
        name             = optional(string)
        description      = optional(string)
        threshold_metric = optional(string), # Default: ACTUAL
        threshold_type   = optional(string), # Default: PERCENTAGE
        threshold_value  = number,
        recipients       = string,
        message          = string,
        defined_tags     = optional(map(string)),
        freeform_tags    = optional(map(string))
      }))
    })))
  })
} 

variable module_name {
  description = "The module name."
  type = string
  default = "budgets"
}

variable compartments_dependency {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type." 
  type = map(any)
  default = null
}