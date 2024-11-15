# Output the API Gateway URL
output "api_gateway_url" {
  value = "https://${google_api_gateway_gateway.gateway.default_hostname}"
}