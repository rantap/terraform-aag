variable "project" {
  description = "The project name"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "cosmosdb_endpoint" {
  description = "The endpoint for the Cosmos DB account"
  type        = string
}

variable "cosmosdb_key" {
  description = "The primary key for the Cosmos DB account"
  type        = string
}

variable "cosmosdb_database_name" {
  description = "The Cosmos DB database name"
  type        = string
}

variable "cosmosdb_container_name" {
  description = "The Cosmos DB container name"
  type        = string
}
