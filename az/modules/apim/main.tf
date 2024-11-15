resource "azurerm_api_management" "api_management" {
  name                = "${var.environment}-${var.project}-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "ExamplePublisher"
  publisher_email     = "publisher@example.com"
  sku_name            = "Consumption_0"
}

resource "azurerm_api_management_api" "api" {
  name                = "${var.environment}-${var.project}-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.api_management.name
  revision            = "1"
  display_name        = "${var.project} API"
  path                = "${var.environment}-api"
  protocols           = ["https"]
}

resource "azurerm_api_management_api_operation" "operation" {
  operation_id        = "${var.project}-operation"
  api_name            = azurerm_api_management_api.api.name
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name
  display_name        = "${var.project} Operation"
  method              = "POST"
  url_template        = "/"
  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation_policy" "operation_policy" {
  operation_id        = azurerm_api_management_api_operation.operation.operation_id
  api_name            = azurerm_api_management_api.api.name
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name
  xml_content         = <<XML
    <policies>
      <inbound>
        <set-backend-service base-url="https://${var.function_app_hostname}/api/    http_trigger" />
      </inbound>
      <backend>
        <forward-request />
      </backend>
      <outbound />
    </policies>
  XML
}