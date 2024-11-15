module "apigw" {
  source      = "./modules/apigw"
  project     = var.project
  region      = var.region
  environment = var.environment
  lambda_arn  = module.lambda.lambda_arn
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  project     = var.project
  environment = var.environment
}

module "lambda" {
  source             = "./modules/lambda"
  project            = var.project
  environment        = var.environment
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}