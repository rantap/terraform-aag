# Storage account (required by the Function App)
resource "azurerm_storage_account" "storage" {
  name                     = "${var.environment}${var.project}storage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "function_container" {
  name                  = "function-code"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Package the function into a zip file
data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/functionapp/" # Path to your function app code
  output_path = "${path.module}/functionapp/function_app.zip"
  excludes = [
    "**/__pycache__",
    "**/.venv",
    "**/function_app.zip",
    "**/local.settings.json"
  ]
}

# Service plan (Consumption Plan)
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.environment}-${var.project}-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1" # Consumption plan for Azure Functions
}

# Function app
resource "azurerm_linux_function_app" "function_app" {
  name                       = "${var.environment}-${var.project}-function-app"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.service_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  app_settings = {
    "PACKAGE_HASH"                   = data.archive_file.function.output_base64sha256 # Ensure Terraform deploys zip file on code change
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "ENABLE_ORYX_BUILD"              = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "COSMOSDB_URL"                   = var.cosmosdb_endpoint
    "COSMOSDB_KEY"                   = var.cosmosdb_key
    "COSMOSDB_DATABASE"              = var.cosmosdb_database_name
    "COSMOSDB_CONTAINER"             = var.cosmosdb_container_name
  }

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  zip_deploy_file = data.archive_file.function.output_path # Function zip path
}