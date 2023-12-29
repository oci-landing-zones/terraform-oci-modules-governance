# CIS OCI Budgets Module Example - Tag Based Budget

This example shows how to manage budgets in Oracle Cloud Infrastructure using the [CIS Landing Zone Budgets module](../..). The configuration provided by this example creates a budget for a specific cost tracking tag. The budget starts in the budget creation day (as *day_of_month_to_begin* is undefined). An alert message is sent if the consumption exceeds the absolute value specified by *threshold_value* attribute.

## Using this example

1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *tags_configuration* input variable, by making the appropriate substitutions: 
   - Replace *\<REPLACE-WITH-COST-TRACKING-TAG\>* placeholder with the cost tracking tag in the following format: **\<tag-namespace\>.\<tag-name\>.\<tag-value\>**, without the \< \> signs.
   - Replace *\<REPLACE-WITH-BUDGET-AMOUNT\>* placeholder with the budget amount.
   - Replace *\<REPLACE-WITH-THRESHOLD-VALUE\>* placeholder with the consumption amount that triggers the alert rule.
   - Replace *\<REPLACE-WITH-EMAIL-ADDRESS\>* placeholder with an actual email address to receive the budget alert message. For multiple addresses, separate them with a comma.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```