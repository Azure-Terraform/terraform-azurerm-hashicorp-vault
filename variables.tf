# Basics
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name"{
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

# Kubernetes 
variable "kubernetes_namespace" {
  description = "kubernetes namespace where vault will be installed"
  type        = string
  default     = "default"
}

# AAD
variable "identity_name" {
  description = "name for Azure identity to be used by AAD"
  type        = string
  default     = "aks-aad"
}

variable "vault_helm_chart_version" {
  description = "version of vault helm chart to use"
  type        = string
  default     = "0.5.0"
}

variable "vault_version" {
  description = "version of Vault to install"
  type        = string
  default     = "1.4.0"
}

variable "vault_agent_injector_version" {
  description = "version of Vault Agent Injector to install"
  type        = string
  default     = "0.3.0"
}

variable "vault_agent_injector_sidecar_version" {
  description = "version of Vault Agent Injectort sidecar to install (defaults to <vault_version>)"
  type        = string
  default     = ""
}

variable "vault_enable_ha" {
  description = "enable ha (clustering)"
  type        = bool
  default     = true
}

variable "vault_enable_raft_backend" {
  description = "enable raft storage backend"
  type        = bool
  default     = true
}

variable "vault_enable_data_storage" {
  description = "enable data storage for raft/file storage backend"
  type        = bool
  default     = true
}

variable "vault_data_storage_class" {
  description = "kubernetes storage class to use for vault data"
  type        = string
  default     = "null"
}

variable "vault_data_storage_size" {
  description = "vault data storage size"
  type        = string
  default     = "10Gi"
}

variable "vault_enable_audit_storage" {
  description = "kubernetes storage class to use for vault audit logs"
  type        = string
  default     = false
}

variable "vault_audit_storage_class" {
  description = "kubernetes storage class to use for vault audit logs"
  type        = string
  default     = "null"
}

variable "vault_audit_storage_size" {
  description = "vault audit storage size"
  type        = string
  default     = "10Gi"
}

variable "vault_audit_data_storage_size" {
  description = "vault audit logs storage size"
  type        = string
  default     = "10Gi"
}