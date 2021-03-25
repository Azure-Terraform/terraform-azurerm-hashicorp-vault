# Hashicorp Vault

## Introduction

This module will deploy hashicorp vault into a pre-existing AKS cluster
<br />

<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0.0 |
| helm | >= 1.2.1 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_yaml\_config | yaml config for helm chart to be processed last | `string` | `""` | no |
| identity\_name | name for Azure identity to be used by AAD | `string` | `"aks-aad"` | no |
| key\_vault\_managers | Azure identities/groups to be granted management access to Azure Key Vault (leave empty for object\_id running terraform) | <pre>map(object({<br>                  tenant_id = string<br>                  object_id = string }))</pre> | n/a | yes |
| kubernetes\_namespace | kubernetes namespace where vault will be installed | `string` | `"default"` | no |
| kubernetes\_node\_selector | kubernetes node selector labels | `map(string)` | `{}` | no |
| location | Azure Region | `string` | n/a | yes |
| names | names to be applied to resources | `map(string)` | n/a | yes |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| tags | tags to be applied to resources | `map(string)` | n/a | yes |
| vault\_agent\_injector\_enabled | enable Vault Agent Injector | `bool` | `true` | no |
| vault\_agent\_injector\_sidecar\_version | version of Vault Agent Injectort sidecar to install (defaults to <vault\_version>) | `string` | `""` | no |
| vault\_agent\_injector\_version | version of Vault Agent Injector to install | `string` | `"0.3.0"` | no |
| vault\_audit\_data\_storage\_size | vault audit logs storage size | `string` | `"10Gi"` | no |
| vault\_audit\_storage\_class | kubernetes storage class to use for vault audit logs | `string` | `"null"` | no |
| vault\_audit\_storage\_size | vault audit storage size | `string` | `"10Gi"` | no |
| vault\_data\_storage\_class | kubernetes storage class to use for vault data | `string` | `"null"` | no |
| vault\_data\_storage\_size | vault data storage size | `string` | `"10Gi"` | no |
| vault\_enable\_audit\_storage | kubernetes storage class to use for vault audit logs | `string` | `false` | no |
| vault\_enable\_data\_storage | enable data storage for raft/file storage backend | `bool` | `true` | no |
| vault\_enable\_ha | enable ha (clustering) | `bool` | `true` | no |
| vault\_enable\_raft\_backend | enable raft storage backend | `bool` | `true` | no |
| vault\_enable\_ui | enable vault ui | `bool` | `true` | no |
| vault\_helm\_chart\_version | version of vault helm chart to use | `string` | `"0.6.0"` | no |
| vault\_ingress\_enabled | enable ingress controller | `bool` | `false` | no |
| vault\_ingress\_hostname | hostname for the ingress controller | `string` | `""` | no |
| vault\_ingress\_tls\_secret\_name | enable ingress controller | `string` | `""` | no |
| vault\_version | version of Vault to install | `string` | `"1.4.2"` | no |

## Outputs

No output.
<!--- END_TF_DOCS --->
<br />
