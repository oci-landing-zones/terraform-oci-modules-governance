# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "budgets" {
  description = "The budgets."
  value = oci_budget_budget.these
}

output "budget_alert_rules" {
  description = "The budget alert rules."
  value = oci_budget_alert_rule.these
}