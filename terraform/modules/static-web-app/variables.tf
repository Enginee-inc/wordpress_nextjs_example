variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the resource will be created"
  type        = string
}

variable "static_web_app_name" {
  description = "The name of the Static Web App"
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier of the Static Web App"
  type        = string
  default     = "Standard"
}

variable "sku_size" {
  description = "The SKU size of the Static Web App"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "custom_domain_name" {
  description = "Custom domain name for the Static Web App"
  type        = string
  default     = ""
}

variable "enable_function_app" {
  description = "Enable function app integration"
  type        = bool
  default     = false
}

variable "function_app_id" {
  description = "ID of the Function App for integration"
  type        = string
  default     = ""
}

variable "app_settings" {
  description = "Application settings for the Static Web App"
  type        = map(string)
  default     = {}
}

variable "repository_url" {
  description = "The URL of the repository for the Static Web App"
  type        = string
}

variable "repository_branch" {
  description = "The branch of the repository for the Static Web App"
  type        = string
  default     = "main"
}

variable "repository_token" {
  description = "The token for accessing the repository"
  type        = string
  sensitive   = true
}