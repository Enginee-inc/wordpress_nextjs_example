output "wordpress_url" {
  description = "WordPress App Service URL"
  value       = "https://${azurerm_linux_web_app.wordpress.default_hostname}"
}

output "nextjs_url" {
  description = "Next.js Static Web App URL"
  value       = "https://${azurerm_static_web_app.nextjs.default_host_name}"
}

output "mysql_server_fqdn" {
  description = "MySQL server FQDN"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "static_web_app_api_key" {
  description = "Static Web App API key for deployment"
  value       = azurerm_static_web_app.nextjs.api_key
  sensitive   = true
}