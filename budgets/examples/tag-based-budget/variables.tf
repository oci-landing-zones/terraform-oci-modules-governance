variable "tenancy_ocid" {}
variable "region" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}

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
        processing_period_type = optional(string) # Default: MONTH. Valid values: MONTH, SINGLE_USE, INVOICE
        day_of_month_to_begin = optional(number), # Only applicable when processing_period_type is MONTH. Default: <current day>.
        single_use_start_date = optional(string), # Only applicable when processing_period_type is SINGLE_USE
        single_use_end_date = optional(string) # Only applicable when processing_period_type is SINGLE_USE
      })),
      defined_tags     = optional(map(string)),
      freeform_tags    = optional(map(string)),
      alert_rule       = optional(object({
        name             = optional(string)
        description      = optional(string)
        threshold_metric = optional(string), # Default: ACTUAL
        threshold_type   = optional(string), # Default: PERCENTAGE
        threshold_value  = number,
        recipients       = optional(string),
        message          = optional(string),
        defined_tags     = optional(map(string)),
        freeform_tags    = optional(map(string))
      }))
    })))
  })
}  