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

variable "function_app_hostname" {
  description = "The function app host url"
  type        = string
}