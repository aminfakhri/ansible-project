resource "azurerm_recovery_services_vault" "assignment1-vault" {
  name                = var.recovery_service_vault_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  soft_delete_enabled = false
  tags = var.tags
}


resource "azurerm_log_analytics_workspace" "assignment1-workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = var.tags
}


resource "azurerm_storage_account" "assignment1-sto-acc" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  tags = var.tags
}


# resource "azurerm_log_analytics_linked_storage_account" "assignment1-linked-workspace-sto-acc" {
#   data_source_type      = "customlogs"
#   resource_group_name   = var.rg_name
#   workspace_resource_id = azurerm_log_analytics_workspace.assignment1-workspace.id
#   storage_account_ids   = [azurerm_storage_account.assignment1-sto-acc.id]
# }


# resource "azurerm_backup_policy_vm" "assignment1-backup-policy" {
#   name                = "assignment-recovery-vault-policy"
#   resource_group_name = var.rg_name
#   recovery_vault_name = var.recovery_service_vault_name
#   backup {
#     frequency = "Daily"
#     time      = "23:00"
#   }
#   retention_daily {
#     count = 10
#   }

#   retention_weekly {
#     count    = 42
#     weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
#   }

#   retention_monthly {
#     count    = 7
#     weekdays = ["Sunday", "Wednesday"]
#     weeks    = ["First", "Last"]
#   }

#   retention_yearly {
#     count    = 77
#     weekdays = ["Sunday"]
#     weeks    = ["Last"]
#     months   = ["January"]
#   }
#   depends_on = [
#     azurerm_recovery_services_vault.assignment1-vault
#   ]
# }

