# OCI Landing Zones Budgets Module Example - Minimal Configuration (Root Compartment Budget)

This example shows how to manage budgets in Oracle Cloud Infrastructure using the [CIS Landing Zone Budgets module](../..). The configuration provided by this example omits all optional attributes in the input variable.
As a result, the monthly recurring budget starting in the budget create day is created for the tenancy Root compartment.

## Using this example

1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *tags_configuration* input variable, by making the appropriate substitutions: 
   - Replace *\<REPLACE-WITH-BUDGET-AMOUNT\>* placeholder with the budget amount.
   - Replace *\<REPLACE-WITH-THRESHOLD-VALUE\>* placeholder with the consumption percentage that triggers the alert rule.
   - Replace *\<REPLACE-WITH-EMAIL-ADDRESS\>* placeholder with an actual email address to receive the budget alert message. For multiple addresses, separate them with a comma.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```