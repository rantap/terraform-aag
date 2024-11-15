# Enable the necessary API services
resource "google_project_service" "apigateway" {
  service            = "apigateway.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "service_control" {
  service            = "servicecontrol.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "service_management" {
  service            = "servicemanagement.googleapis.com"
  disable_on_destroy = false
}

# Define the Google API Gateway configuration
resource "google_api_gateway_api" "api" {
  provider     = google-beta
  api_id       = "${var.environment}-${var.project}-api"
  display_name = "${var.environment}-${var.project} API"

  depends_on = [google_project_service.apigateway] # Ensure the API is enabled before creation
}

# API Config that defines the endpoint routing
resource "google_api_gateway_api_config" "api_config" {
  provider      = google-beta
  api           = google_api_gateway_api.api.api_id
  api_config_id = "${var.environment}-${var.project}-api-config"
  display_name  = "API Config for ${var.environment}-${var.project}"

  openapi_documents {
    document {
      path = "api_gateway_openapi.yaml"
      contents = base64encode(<<EOF
        swagger: "2.0"
        info:
          title: ${var.environment}-${var.project}-api
          version: "1.0"
        paths:
          /:
            post:
              operationId: postId
              x-google-backend:
                address: ${var.function_url}
              responses:
                '200':
                  description: A successful response
      EOF
      )
    }
  }
  depends_on = [google_api_gateway_api.api]
}

# Deploy the API Gateway
resource "google_api_gateway_gateway" "gateway" {
  provider   = google-beta
  region     = "europe-west1" # europe-north1 used elsewhere is not available in API GW
  api_config = google_api_gateway_api_config.api_config.id
  gateway_id = "${var.environment}-${var.project}-gateway"
}
