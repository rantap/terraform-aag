variable "project" {
  description = "The project name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "The environment to deploy (dev, prod, etc.)"
  type        = string
}

variable "lambda_arn" {
  description = "The ARN of the Lambda to access"
  type        = string
}