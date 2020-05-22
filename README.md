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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| identity\_name | name for Azure identity to be used by AAD | `string` | `"aks-aad"` | no |
| kubernetes\_namespace | kubernetes namespace where vault will be installed | `string` | `"default"` | no |
| location | Azure Region | `string` | n/a | yes |
| names | names to be applied to resources | `map(string)` | n/a | yes |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| subscription\_id | Azure Subscription ID | `string` | n/a | yes |
| tags | tags to be applied to resources | `map(string)` | n/a | yes |
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
| vault\_helm\_chart\_version | version of vault helm chart to use | `string` | `"0.5.0"` | no |
| vault\_version | version of Vault to install | `string` | `"1.4.0"` | no |

## Outputs

No output.
<!--- END_TF_DOCS --->
<br />

## Example

~~~~
provider "azurerm" {
  version = ">=2.0.0"
  features {}
  subscription_id = "00000-0000-0000-0000-0000000"
}

# Subscription
module "subscription" {
  source = "git@github.com:Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
}

# Metadata
module "metadata" {
  source = "git@github.com:Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.0.0"

  subscription_id     = module.subscription.output.subscription_id
  # These values should be taken from https://github.com/openrba/python-azure-naming
  business_unit       = "rba.businessUnit"
  cost_center         = "rba.costCenter"
  environment         = "rba.environment"
  location            = "rba.azureRegion"
  market              = "rba.market"
  product_name        = "rba.productName"
  product_group       = "rba.productGroup"
  project             = "project-url"
  sre_team            = "team-name"
  subscription_type   = "rba.subscriptionType"
  resource_group_type = "rba.resourceGroupType"

  additional_tags = {
    "example" = "an additional tag"
  }
}

# Resource group
module "resource_group" {
  source = "git@github.com:Azure-Terraform/terraform-azurerm-resource-group.git?ref=v1.0.0"

  location = module.metadata.location
  tags     = module.metadata.tags
  name     = module.metadata.names
}

# AKS
## This will create a managed kubernetes cluster
module "aks" {
  source = "git@github.com:Azure-Terraform/terraform-azurerm-kubernetes.git"

  service_principal_id     = var.service_principal_id
  service_principal_secret = var.service_principal_secret
  service_principal_name   = "ris-azr-app-infrastructure-aks-test"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  names = module.metadata.names
  tags  = module.metadata.tags

  kubernetes_version = "1.16.7"

  default_node_pool_name                = "default"
  default_node_pool_vm_size             = "Standard_D2s_v3"
  default_node_pool_enable_auto_scaling = true
  default_node_pool_node_min_count      = 1
  default_node_pool_node_max_count      = 5
  default_node_pool_availability_zones  = [1,2,3]

  enable_kube_dashboard = true

}

# Kubernetes
## (Optional) add new storage class for geo-redundant storage
provider "kubernetes" {
  load_config_file       = "false"
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

resource "kubernetes_storage_class" "azurefile_grs" {
   metadata {
     name = "azurefile-grs"
   }
   storage_provisioner = "kubernetes.io/azure-file"
   reclaim_policy      = "Retain"
   parameters = {
     skuName = "Standard_GRS"
   }
   mount_options = ["dir_mode=0777", "file_mode=0777", "uid=0", "gid=0", "mfsymlinks", "cache=strict"]
}

# Helm
provider "helm" {
  alias = "aks"
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

module "aad-pod-identity" {
  source = "git@github.com:Azure-Terraform/terraform-azurerm-kubernetes.git/aad-pod-identity"

  providers = {
    helm = helm.aks
  }

  resource_group_name    = module.resource_group.name
  service_principal_name = "ris-azr-app-infrastructure-aks-test"

  aad_pod_identity_version = "1.6.0"
}

# Vault
## This will setup a vault cluster with a raft storage backend using azurefile GRS
module "vault" {
  source = "git@github.com:Azure-Terraform/terraform-azurerm-hashicorp-vault.git"

  providers = {
    helm = helm.aks
  }

  kubectl_host                   = module.aks.host
  kubectl_username               = module.aks.username
  kubectl_password               = module.aks.password
  kubectl_client_certificate     = module.aks.client_certificate
  kubectl_client_key             = module.aks.client_key
  kubectl_cluster_ca_certificate = module.aks.cluster_ca_certificate

  subscription_id                 = module.subscription.output.subscription_id
  aks_service_principal_client_id = module.aks.service_principal_client_id

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  names = module.metadata.names
  tags  = module.metadata.tags

  azure_key_vault_id                  = module.key_vault.id
  azure_key_vault_name                = module.key_vault.name
  azure_key_vault_resource_group_name = module.key_vault.resource_group_name

  vault_enable_ha              = true
  vault_enable_raft_backend    = true
  vault_version                = "1.4.0"
  vault_agent_injector_version = "0.3.0"
  vault_data_storage_class     = "azurefile-grs"

}
~~~~
