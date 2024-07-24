# OCI Landing Zones Tags Module Example - Vision Tags with External Dependencies

This example shows how to manage defined tags in Oracle Cloud Infrastructure for a hypothetical Vision entity using the [OCI Landing Zones Tags module](../..). It is functionally equivalent to the [vision example](../vision/). The difference is that it takes compartment dependencies from a file that sits in OCI Object Storage bucket.

As this example needs to read from an OCI Object Storage bucket, the following extra permissions are required for the executing user, in addition to the permissions required by the [tags module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<REPLACE-BY-BUCKET-NAME>'
```
Note: *\<bucket-compartment-name\>* is *\<REPLACE-BY-BUCKET-NAME\>*'s compartment.

## External Dependencies

The OCI Object Storage objects with the external dependencies are expected to have structures like the following:
- **oci_compartments_dependency**
```
{
  "APP-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...zrt"
  }
}
```

## Using this example

1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *tags_configuration* input variable, by making the appropriate substitutions: 
   - Replace *\<REPLACE-BY-TAG-NAMESPACE-COMPARTMENT-REFERENCE\>* placeholder with the compartment reference key in *\<REPLACE-BY-OBJECT-NAME-FOR-COMPARTMENTS\>* file.
   - If applying tag defaults, replace *\<REPLACE-BY-COMPARTMENT-REFERENCE\>* placeholder with the compartment reference key in *\<REPLACE-BY-OBJECT-NAME-FOR-COMPARTMENTS\>* file. Otherwise, remove *tag_defaults* attributes altogether.
   - Replace *\<REPLACE-BY-BUCKET-NAME\>* placeholder with the bucket name containing the object with compartment dependencies.
   - Replace *\<REPLACE-BY-OBJECT-NAME-FOR-COMPARTMENTS\>* placeholder with the Object Storage object name containing the compartment dependencies.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```