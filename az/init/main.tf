provider "azurerm" {
  features {}
}

# Define resource group for state storage
resource "azurerm_resource_group" "state_rg" {
  name     = "${var.project}-state-rg"
  location = var.location
}

# Create storage account
resource "azurerm_storage_account" "tf_state_account" {
  name                     = "${var.project}stateaccount"
  resource_group_name      = azurerm_resource_group.state_rg.name
  location                 = azurerm_resource_group.state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }
}

# Create blob container for state file
resource "azurerm_storage_container" "tf_state_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tf_state_account.id
  container_access_type = "private"
}
