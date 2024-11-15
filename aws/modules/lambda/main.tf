# Define IAM role for Lambda to allow access to DynamoDB
resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-${var.project}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Define IAM policy for Lambda to access DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "${var.environment}-${var.project}-lambda-dynamodb-policy"
  description = "Policy to allow Lambda function to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "${var.dynamodb_table_arn}"
      }
    ]
  })
}

# Attach policy to Lambda IAM role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.environment}-${var.project}-lambda-function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  filename      = "modules/lambda/lambdas/lambda_function.zip" # Pre-packaged zip of your Lambda function code

  # Ensure Terraform redeploys on code changes
  source_code_hash = filebase64sha256("modules/lambda/lambdas/lambda_function.zip")

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}