resource "aws_dynamodb_table" "table" {
  name         = "${var.environment}-${var.project}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S" # String type
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = {
    "Environment" = "${var.environment}-${var.project}"
  }
}

# Output the table ARN for IAM role policy in the Lambda module
output "dynamodb_table_arn" {
  value = aws_dynamodb_table.table.arn
}