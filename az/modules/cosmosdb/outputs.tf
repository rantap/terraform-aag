output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.example.endpoint
}

output "cosmosdb_key" {
  value = azurerm_cosmosdb_account.example.primary_key
}

output "cosmosdb_database_name" {
  value = azurerm_cosmosdb_sql_database.main.name
}

output "cosmosdb_container_name" {
  value = azurerm_cosmosdb_sql_container.example.name
}