# CIS OCI Tags Module Example - Vision Tags

This example shows how to manage defined tags in Oracle Cloud Infrastructure for a hypothetical Vision entity using the [CIS Landing Zone Tags module](../..).

The following resources are created in this example:

- One tag namespace: vision.
- Three tags: cost-center, environment-class, resource-id.
- Tag defaults for cost-center and environment-class in compartments of choice.

If *Oracle-Tags* namespace is not defined in the tenancy, the example creates a tag namespace and tags for identifying resource creators (*CreatedBy*) and the time when resources are created (*CreatedOn*). These tags are recommended by CIS OCI Foundations Benchmark. If for some reason you want to disable them, remove *cislz_namespace_name* attribute from *tags_configuration* in [input.auto.tfvars.template](./input.auto.tfvars.template).

## Using this example

1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *tags_configuration* input variable, by making the appropriate substitutions: 
   - Replace *\<REPLACE-BY-TAG-NAMESPACE-COMPARTMENT-OCID\>* placeholder with the compartment ocid for tag namespaces.
   - If applying tag defaults, replace *\<REPLACE-BY-COMPARTMENT-OCID\>* placeholders with actual compartment ocids. Otherwise, remove *tag_defaults* attributes altogether.

You can now skip directly to step 3. Read the rest to understand what is in the input variable.

The *tags_configuration* variable defines a Terraform object describing any set of OCI IAM defined_tags resources.
The object is a three level map, with the first level defining the tag namespaces, the second level defining
the tags and the third level defining tag defaults. Each map element is indexed by a unique string in uppercase, 
like VISION-NAMESPACE, COST-CENTER-TAG, ENVIRONMENT-TAG, COST-CENTER-TAG-DEFAULT, etc. These strings can actually 
be any random strings, but once defined they MUST NOT BE CHANGED, or Terraform will try to destroy and recreate 
the resources.

The *cis_namespace_name* attribute, if defined, drives the creation of a namespace with *CreatedBy* and *CreatedOn* tags, unless
*Oracle-Tags* namespace is already defined in the tenancy. This is a recommendation of CIS OCI Foundations Benchmark.

Within the *tags* attribute:
- *is_cost_tracking* defines whether the tag is used for cost tracking.
- *is_retired* indicates whether the tag is retired. Retired tags are no longer applied to resources.
- *valid_values* enforce the allowed values for the tag. 
- *tag_defaults* define the compartments where to auto apply defaults or require a value from users.
   - *compartment_ocids*: list of compartments to apply defaults to.
   - *default_value*: the value to auto apply.
   - *is_user_required*: when true, *default_value* is ignored and user must provide a value. When false or absent, *default_value* is applied.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```