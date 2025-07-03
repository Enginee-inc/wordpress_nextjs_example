resource "azurerm_static_web_app" "frontend" {
  name                = var.static_web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = var.sku_tier
  sku_size            = var.sku_size
  tags                = var.tags

  repository_url = "${var.repository_url}"
  repository_branch = "${var.repository_branch}"
  repository_token = var.repository_token


  identity {
    type = "SystemAssigned"
  }
}

# Custom domain configuration (optional)
resource "azurerm_static_web_app_custom_domain" "custom" {
  count               = var.custom_domain_name != "" ? 1 : 0
  static_web_app_id   = azurerm_static_web_app.frontend.id
  domain_name         = var.custom_domain_name
  validation_type     = "cname-delegation"
}

# Application settings for the Static Web App
resource "azurerm_static_web_app_function_app_registration" "frontend_settings" {
  count             = var.enable_function_app ? 1 : 0
  static_web_app_id = azurerm_static_web_app.frontend.id
  function_app_id   = var.function_app_id
}

resource "azurerm_application_insights" "main" {
  name                = "${var.static_web_app_name}-ai"
  location            = azurerm_static_web_app.frontend.location
  resource_group_name = azurerm_static_web_app.frontend.resource_group_name
  application_type    = "web"

  tags = var.tags
  
}