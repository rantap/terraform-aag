# API Gateway REST API
resource "aws_api_gateway_rest_api" "example" {
  name        = "${var.environment}-api"
  description = "API for Lambda Integration"
}

# API Gateway Resource (path part `/lambda`)
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "lambda"
}

# Define GET method for /lambda
resource "aws_api_gateway_method" "get_lambda" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integration with Lambda (use AWS_PROXY for direct Lambda invocation)
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get_lambda.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

# Grant API Gateway permission to invoke Lambda
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

# Deployment resource to create a new deployment
resource "aws_api_gateway_deployment" "apigw_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = var.environment # Use environment variable here
}

output "api_url" {
  value       = "https://${aws_api_gateway_rest_api.example.id}.execute-api.${var.region}.amazonaws.com/${var.project}-${var.environment}"
  description = "Base URL of the API Gateway endpoint"
}