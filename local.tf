locals {
  key_vault_managers = (var.key_vault_managers != null ? var.key_vault_managers :
                       { current = { tenant_id = data.azurerm_client_config.current.tenant_id
                                     object_id = data.azurerm_client_config.current.object_id }} )
}
