# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "tag_namespaces" {
  description = "The tag namespaces."
  value       = module.cislz_tags.tag_namespaces
}

output "tags" {
  description = "The tags."
  value       = module.cislz_tags.tags
}

output "tag_defaults" {
  description = "The tag defaults."
  value       = module.cislz_tags.tag_defaults
}
