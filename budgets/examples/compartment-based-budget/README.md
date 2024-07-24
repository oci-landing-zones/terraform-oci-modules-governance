# OCI Landing Zones Budgets Module Example - Compartment Based Budget

This example shows how to manage budgets in Oracle Cloud Infrastructure using the [CIS Landing Zone Budgets module](../..). The configuration provided by this example creates a budget for a specific target compartment. The budget starts in the first day of the current month.

## Using this example

1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *tags_configuration* input variable, by making the appropriate substitutions: 
   - Replace *\<REPLACE-WITH-COMPARTMENT-OCID\>* placeholder with the target compartment OCID.
   - Replace *\<REPLACE-WITH-BUDGET-AMOUNT\>* placeholder with the budget amount.
   - Replace *\<REPLACE-WITH-THRESHOLD-VALUE\>* placeholder with the consumption percentage that triggers the alert rule.
   - Replace *\<REPLACE-WITH-EMAIL-ADDRESS\>* placeholder with an actual email address to receive the budget alert message. For multiple addresses, separate them with a comma.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```