# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#-- This module creates tag namespaces, tags and tag defaults 

locals {
  oracle_tags_namespace = "Oracle-Tags" #-- used in namespace data source lookup. See data_sources.tf

  #-------------------------------------------------------------------------------------
  #-- Namespace recommended by CIS - only if Oracle-Tags namespace is not defined
  #-------------------------------------------------------------------------------------
  #-- Naming
  cis_namespace_name = var.tags_configuration.cis_namespace_name != null ? var.tags_configuration.cis_namespace_name : "cis-namespace"
  cis_namespace_key = "CIS-NAMESPACE"

  #-- The namespace
  cis_namespace = var.tags_configuration.cis_namespace_name != null && length(data.oci_identity_tag_namespaces.oracle_default.tag_namespaces) == 0 ? {
    (local.cis_namespace_key) = {
      compartment_ocid = var.tenancy_ocid
      name = local.cis_namespace_name
      description = "CIS recommended tag namespace."
      is_retired = false
      defined_tags  = var.tags_configuration.default_defined_tags
      freeform_tags = var.tags_configuration.default_freeform_tags
    }
  } : {}

  #-------------------------------------------------------------------------------------------------
  #-- CreatedBy tag recommended by CIS - only if not already defined in Oracle-Tags namespace
  #-------------------------------------------------------------------------------------------------
  #-- Naming
  cis_created_by_tag_key  = "CIS-CREATED-BY-TAG"
  cis_created_by_tag_name = "CreatedBy"
  
  #-- The tag itself
  cis_created_by_tag = var.tags_configuration.cis_namespace_name != null && length(data.oci_identity_tag.default_created_by) == 0 ? {
    (local.cis_created_by_tag_key) = {
      name = local.cis_created_by_tag_name,
      description = "Tag to identify the resource creator.",
      tag_namespace_id = oci_identity_tag_namespace.these[local.cis_namespace_key].id
      is_cost_tracking = true,
      is_retired = false,
      valid_values = []
      defined_tags  = var.tags_configuration.default_defined_tags
      freeform_tags = var.tags_configuration.default_freeform_tags
    }
  } : {} 

  #-- Tag default
  cis_created_by_tag_default = var.tags_configuration.cis_namespace_name != null && length(data.oci_identity_tag.default_created_by) == 0 ? {
    (local.cis_created_by_tag_key) = {
      tag_definition_id = oci_identity_tag.these[local.cis_created_by_tag_key].id
      compartment_id = var.tenancy_ocid,
      default_value = "$${iam.principal.name}",
      is_user_required = false
    }
  } : {}

  #-----------------------------------------------------------------------------------------------
  #-- CreatedOn tag recommended by CIS - only if not already defined in Oracle-Tags namespace
  #-----------------------------------------------------------------------------------------------
  #-- Naming
  cis_created_on_tag_key = "CIS-CREATED-ON-TAG"
  cis_created_on_tag_name = "CreatedOn"

  #-- The tag itself
  cis_created_on_tag = var.tags_configuration.cis_namespace_name != null && length(data.oci_identity_tag.default_created_on) == 0 ? {
    (local.cis_created_on_tag_key) = {
      name = local.cis_created_on_tag_name,
      description = "Tag to identify when resources are created.",
      tag_namespace_id = oci_identity_tag_namespace.these[local.cis_namespace_key].id
      is_cost_tracking = false,
      is_retired = false,
      valid_values = []
      defined_tags  = var.tags_configuration.default_defined_tags
      freeform_tags = var.tags_configuration.default_freeform_tags
    }
  } : {}

  #-- Tag default
  cis_created_on_tag_default = var.tags_configuration.cis_namespace_name != null && length(data.oci_identity_tag.default_created_on) == 0 ? {
    (local.cis_created_on_tag_key) = {
      tag_definition_id = oci_identity_tag.these[local.cis_created_on_tag_key].id
      compartment_id = var.tenancy_ocid,
      default_value = "$${oci.datetime}",
      is_user_required = false
    }
  } : {}

  #---------------------------------------------------------------------------------------
  #-- Building an array with all tags passed in tags attribute
  #---------------------------------------------------------------------------------------
  tags = var.tags_configuration.namespaces != null ? flatten([
    for k1,v1 in var.tags_configuration.namespaces : [
      for k2, v2 in v1.tags : {
        key  = k2
        name = v2.name
        description = v2.description
        namespace_id = oci_identity_tag_namespace.these[k1].id
        is_cost_tracking = v2.is_cost_tracking != null ? v2.is_cost_tracking : false
        is_retired = v2.is_retired != null ? v2.is_retired : false
        valid_values = v2.valid_values
        defined_tags = v2.defined_tags
        freeform_tags = v2.freeform_tags
      } 
    ] if v1.tags != null
  ]) : []

  #---------------------------------------------------------------------------------------
  #-- Building an array with all tag defaults passed in tags attribute
  #---------------------------------------------------------------------------------------
  tag_defaults = var.tags_configuration.namespaces != null ? flatten([
    for v1 in var.tags_configuration.namespaces : [
      for k2, v2 in v1.tags : [
        for k3, v3 in v2.tag_defaults : [
          for cmp in v3.compartment_ocids : {
            key  = "${k3}.${cmp}"
            tag_definition_id = oci_identity_tag.these[k2].id
            compartment_id = cmp
            default_value = v3.default_value
            is_user_required = v3.is_user_required != null ? v3.is_user_required : false
          } 
        ] if v3.compartment_ocids != null
      ] if v2.tag_defaults != null
    ] if v1.tags != null
  ]) : []                 
}

#-- Tag namespaces creation. 
#-- It loops through a merged map of namespaces and the optional local cis_namespace.
resource "oci_identity_tag_namespace" "these" {
  for_each = merge(var.tags_configuration.namespaces != null ? var.tags_configuration.namespaces : {}, local.cis_namespace)
    compartment_id = each.value.compartment_ocid != null ? each.value.compartment_ocid : var.tags_configuration.default_compartment_ocid != null ? var.tags_configuration.default_compartment_ocid : var.tenancy_ocid
    name           = each.value.name
    description    = each.value.description
    is_retired     = each.value.is_retired != null ? each.value.is_retired : false
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

#-- Tags creation.
#-- It loops through a merged map of externally provided tags and the optional locals cis_created_by_tag and cis_created_on_tag.
resource "oci_identity_tag" "these" {
  for_each = merge({for t in local.tags : t.key => {name: t.name, 
                                                    description: t.description,
                                                    tag_namespace_id : t.namespace_id
                                                    is_cost_tracking: t.is_cost_tracking,
                                                    is_retired: t.is_retired,
                                                    valid_values: t.valid_values,
                                                    defined_tags: t.defined_tags,
                                                    freeform_tags: t.freeform_tags}},local.cis_created_by_tag, local.cis_created_on_tag)
    name             = each.value.name
    description      = each.value.description
    tag_namespace_id = each.value.tag_namespace_id
    is_cost_tracking = each.value.is_cost_tracking
    is_retired       = each.value.is_retired
    defined_tags     = each.value.defined_tags
    freeform_tags    = each.value.freeform_tags
    dynamic "validator" {
    for_each = each.value.valid_values != null ? (length(each.value.valid_values) > 0 ? [1] : []) : []
      content {
        validator_type = "ENUM"
        values = each.value.valid_values
      }
    }
}

#-- Tag defaults creation.
#-- It loops through a merged map of externally provided tag defaults and the optional locals cis_created_by_tag and cis_created_on_tag.
resource "oci_identity_tag_default" "these" {
  for_each = merge({for td in local.tag_defaults : td.key => {tag_definition_id: td.tag_definition_id,
                                                              compartment_id: td.compartment_id,
                                                              default_value: td.default_value,
                                                              is_user_required: td.is_user_required}},local.cis_created_by_tag_default, local.cis_created_on_tag_default)
    compartment_id    = each.value.compartment_id
    tag_definition_id = each.value.tag_definition_id                         
    value             = each.value.default_value       
    is_required       = each.value.is_user_required 
}