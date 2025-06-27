variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-wordpress-nextjs"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "wp-nextjs"
}

variable "mysql_admin_username" {
  description = "MySQL admin username"
  type        = string
  default     = "wpadmin"
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}

variable "wordpress_db_name" {
  description = "WordPress database name"
  type        = string
  default     = "wordpress"
}

variable "github_repo_url" {
  description = "GitHub repository URL for Static Web App"
  type        = string
}

variable "deployment_username" {
  description = "App Service deployment username"
  type        = string
  default     = "wpdeployuser"
}

variable "deployment_password" {
  description = "App Service deployment password"
  type        = string
  sensitive   = true
}

variable "wordpress_site_title" {
  description = "WordPress site title"
  type        = string
  default     = "Secure WordPress Site"
}

variable "wordpress_admin_user" {
  description = "WordPress admin username"
  type        = string
  default     = "wpadmin"
}

variable "wordpress_admin_password" {
  description = "WordPress admin password"
  type        = string
  sensitive   = true
}

variable "wordpress_admin_email" {
  description = "WordPress admin email"
  type        = string
}

variable "enable_application_gateway" {
  description = "Enable Application Gateway for enterprise security"
  type        = bool
  default     = false
}