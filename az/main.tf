resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.project}-rg"
  location = var.location
}

module "apim" {
  source                = "./modules/apim"
  project               = var.project
  location              = var.location
  environment           = var.environment
  resource_group_name   = azurerm_resource_group.rg.name
  function_app_hostname = module.functions.function_app_hostname
}

module "cosmosdb" {
  source              = "./modules/cosmosdb"
  project             = var.project
  location            = var.location
  environment         = var.environment
  resource_group_name = azurerm_resource_group.rg.name
}

module "functions" {
  source                  = "./modules/functions"
  project                 = var.project
  location                = var.location
  environment             = var.environment
  resource_group_name     = azurerm_resource_group.rg.name
  cosmosdb_endpoint       = module.cosmosdb.cosmosdb_endpoint
  cosmosdb_key            = module.cosmosdb.cosmosdb_key
  cosmosdb_database_name  = module.cosmosdb.cosmosdb_database_name
  cosmosdb_container_name = module.cosmosdb.cosmosdb_container_name
}