variable "project" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The environment to deploy (e.g., dev, prod)"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table to access"
  type        = string
}