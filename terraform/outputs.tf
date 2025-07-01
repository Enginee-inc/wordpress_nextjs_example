output "wordpress_url" {
  description = "WordPress site URL"
  value       = "https://${azurerm_linux_web_app.wordpress_web_app.default_hostname}"
}

output "wordpress_api_url" {
  description = "WordPress REST API URL"
  value       = "https://${azurerm_linux_web_app.wordpress_web_app.default_hostname}/wp-json"
}

output "static_web_app_url" {
  description = "Static Web App URL"
  value       = "https://${module.static_web_app.default_hostname}"
}

output "static_web_app_api_key" {
  description = "Static Web App API Key for deployment"
  value       = module.static_web_app.api_key
  sensitive   = true
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.resource_group.name
}

output "mysql_server_name" {
  description = "MySQL Server Name"
  value       = azurerm_mysql_flexible_server.mysql_db_server.name
}