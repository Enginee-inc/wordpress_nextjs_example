resource "azurerm_static_web_app" "nextjs" {
  name                = "${var.prefix}-nextjs"
  resource_group_name = azurerm_resource_group.main.name
  location           = "East US 2"
  sku_tier           = "Free"
  sku_size          = "Free"

  app_settings = {
    "WORDPRESS_API_URL" = "https://${azurerm_linux_web_app.wordpress.default_hostname}/wp-json/wp/v2"
  }
}