## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| oci | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_identity_tag_default.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartments_dependency | Compartments keyed by logical references, each containing a string `id` attribute. | `map(any)` | `null` | no |
| tag_defaults_configuration | Defaults keyed by stable resource keys. Each object contains `tag_definition_id`, `compartment_id`, and `default_value` strings, plus optional `is_user_required` (default `false`). | `map(object)` | `{}` | no |
| tenancy_ocid | The tenancy OCID used for `TENANCY-ROOT` compartment references. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| tag_defaults | The tag default resources, keyed by the input map keys. |
