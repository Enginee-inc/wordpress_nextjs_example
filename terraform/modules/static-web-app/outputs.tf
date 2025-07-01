output "id" {
  description = "The ID of the Static Web App"
  value       = azurerm_static_web_app.frontend.id
}

output "default_hostname" {
  description = "The default hostname of the Static Web App"
  value       = azurerm_static_web_app.frontend.default_host_name
}

output "api_key" {
  description = "The API key of the Static Web App"
  value       = azurerm_static_web_app.frontend.api_key
  sensitive   = true
}

output "identity_principal_id" {
  description = "The Principal ID of the system-assigned identity"
  value       = azurerm_static_web_app.frontend.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "The Tenant ID of the system-assigned identity"
  value       = azurerm_static_web_app.frontend.identity[0].tenant_id
}