# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "cislz_budgets" {
  source       = "../.."
  tenancy_ocid = var.tenancy_ocid
  budgets_configuration = var.budgets_configuration
}