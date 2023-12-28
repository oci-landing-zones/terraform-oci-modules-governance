# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource oci_budget_budget these {
  for_each = var.budgets_configuration.budgets
    #compartment_id                        = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (var.budgets_configuration.default_compartment_id != null ? (length(regexall("^ocid1.*$", var.budgets_configuration.default_compartment_id)) > 0 ? var.budgets_configuration.default_compartment_id : var.compartments_dependency[var.budgets_configuration.default_compartment_id].id) : var.tenancy_ocid)
    compartment_id                        = var.tenancy_ocid
    display_name                          = each.value.name
    description                           = each.value.description != null ? each.value.description : each.value.name
    target_type                           = each.value.target != null ? coalesce(each.value.target.type,"COMPARTMENT") : "COMPARTMENT"
    targets                               = each.value.target != null ? (coalesce(each.value.target.type,"COMPARTMENT") == "COMPARTMENT" ? [for v in coalesce(each.value.target.values,[]) : length(regexall("^ocid1.*$", v)) > 0 ? v : var.compartments_dependency[v].id] : each.value.target.values) : [var.tenancy_ocid]
    amount                                = each.value.amount
    budget_processing_period_start_offset = each.value.schedule != null ? (coalesce(each.value.schedule.processing_period_type,"MONTH") == "MONTH" ? (each.value.schedule.day_of_month_to_begin != null ? each.value.schedule.day_of_month_to_begin : formatdate("DD",timestamp())) : null) : formatdate("DD",timestamp())
    reset_period                          = each.value.schedule != null ? coalesce(each.value.schedule.reset_period,"MONTHLY") : "MONTHLY"
    processing_period_type                = each.value.schedule != null ? coalesce(each.value.schedule.processing_period_type,"MONTH") : "MONTH" 
    start_date                            = each.value.schedule != null ? (each.value.schedule.processing_period_type == "SINGLE_USE" ? (each.value.schedule.single_use_start_date != null ? "${each.value.schedule.single_use_start_date}T00:00:00" : formatdate("YYYY-MM-DD'T'hh:mm:ss",timestamp())) : null) : null
    end_date                              = each.value.schedule != null ? (each.value.schedule.processing_period_type == "SINGLE_USE" ? (each.value.schedule.single_use_end_date != null ? "${each.value.schedule.single_use_end_date}T23:59:59" : formatdate("YYYY-MM-DD'T'hh:mm:ss",timeadd(timestamp(),"720h"))) : null) : null
    defined_tags                          = each.value.defined_tags != null ? each.value.defined_tags : (var.budgets_configuration.default_defined_tags != null ? var.budgets_configuration.default_defined_tags : null)
    freeform_tags                         = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : (var.budgets_configuration.default_freeform_tags != null ? var.budgets_configuration.default_freeform_tags : null))
}

resource oci_budget_alert_rule these {
  for_each = { for k, v in var.budgets_configuration.budgets : k => v if v.alert_rule != null }
    budget_id       = oci_budget_budget.these[each.key].id
    display_name    = coalesce(each.value.alert_rule.name,"${oci_budget_budget.these[each.key].display_name}-alert-rule")
    description     = coalesce(each.value.alert_rule.description,"${oci_budget_budget.these[each.key].description} (alert rule)")
    type            = coalesce(each.value.alert_rule.threshold_metric,"ACTUAL")
    threshold_type  = coalesce(each.value.alert_rule.threshold_type,"PERCENTAGE")
    threshold       = each.value.alert_rule.threshold_value
    recipients      = each.value.alert_rule.recipients
    message         = each.value.alert_rule.message
    defined_tags    = each.value.alert_rule.defined_tags != null ? each.value.alert_rule.defined_tags : (each.value.defined_tags != null ? each.value.defined_tags : (var.budgets_configuration.default_defined_tags != null ? var.budgets_configuration.default_defined_tags : null))
    freeform_tags   = merge(local.cislz_module_tag, each.value.alert_rule.freeform_tags != null ? each.value.alert_rule.freeform_tags : (each.value.freeform_tags != null ? each.value.freeform_tags : (var.budgets_configuration.default_freeform_tags != null ? var.budgets_configuration.default_freeform_tags : null)))
}