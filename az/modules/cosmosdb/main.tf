resource "azurerm_cosmosdb_account" "example" {
  name                = "${var.environment}-${var.project}-admin"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # Define NoSQL database type

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "${var.environment}-nosqldb"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.example.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "example" {
  name                = "${var.environment}-container"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.example.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths = ["/id"]
  throughput          = 400
}