# November 3, 2026 Release Notes - 0.2.0
## New
1. [Tag Namespaces and Tags](./tags/namespaces-and-tags/) and [Tag Defaults](./tags/defaults/) submodules allow namespaces and tags to be created before compartments, with defaults created after their target compartments exist. The namespaces-and-tags output `tag_defaults_configuration` preserves existing default keys and resolves tag definition IDs without requiring target compartment IDs at that stage.

## Upgrade notes
1. The existing [Tags module](./tags/) retains its inputs and outputs and delegates to the two submodules. Included `moved` blocks migrate existing namespace, tag and default state addresses automatically; no manual state commands are required. The minimum Terraform version remains 1.3.0.
2. Direct submodule consumers control creation ordering. Create defaults after their target compartments and wait for propagation before creating resources that should inherit them. Defaults do not retroactively tag existing resources.

# November 5, 2025 Release Notes - 0.1.6
## Updates
1. [Tags Module](./tags/)
   - Support for reserved key value "TENANCY-ROOT" when referring to Root compartment OCID in attribute *compartment_ids* when creating tag defaults.
2. Formatted the code to adhere to Terraform standards.

# April 01, 2025 Release Notes - 0.1.5
## Updates
1. [Tags Module](./tags/)    
    - Attribute *default_compartment_id* made optional in *tags_configuration*.
    - Support for reserved key value "TENANCY-ROOT" when referring to Root compartment OCID in attributes *default_compartment_id* and *compartment_id*.

# August 27, 2024 Release Notes - 0.1.4
## Updates
1. All modules now require Terraform binary equal or greater than 1.3.0.
2. *cislz-terraform-module* tag renamed to *ocilz-terraform-module*.

# July 24, 2024 Release Notes - 0.1.3
## Updates    
1. Aligned [README.md](./README.md) structure to Oracle's GitHub organizations requirements.

# January 15, 2024 Release Notes - 0.1.2
## New
1. A module for budgets is available. It manages budgets based on compartments or cost-tracking tags and alert messages based on specific thresholds.
## Updates
1. The Tags module can now declare an external dependency on IAM compartments.


# July 03, 2023 Release Notes - 0.1.1
## Updates
1. [Release Metadata](#0-1-1-metadata)
### <a name="0-1-1-metadata">Release Metadata</a>
Managed resources are tagged with release metadata.


# March 23, 2023 Release Notes - 0.1.0
## New
1. [Initial Release](#0-1-0-initial)
### <a name="0-1-0-initial">Initial Release</a>
Module for tags.
