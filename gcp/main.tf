module "apigw" {
  source       = "./modules/apigw"
  project_id   = var.project_id
  project      = var.project
  region       = var.region
  environment  = var.environment
  function_url = module.functions.function_url
}

module "firestore" {
  source      = "./modules/firestore"
  project_id  = var.project_id
  project     = var.project
  region      = var.region
  environment = var.environment
}

module "functions" {
  source      = "./modules/functions"
  project_id  = var.project_id
  project     = var.project
  region      = var.region
  environment = var.environment
}
