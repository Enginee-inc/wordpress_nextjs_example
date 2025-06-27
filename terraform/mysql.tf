resource "azurerm_mysql_flexible_server" "main" {
  name                   = "${var.prefix}-mysql"
  resource_group_name    = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name              = "B_Standard_B1s"
  version               = "8.0.21"
  
  storage {
    size_gb = 20
  }

  backup_retention_days = 7
}

resource "azurerm_mysql_flexible_database" "wordpress" {
  name                = var.wordpress_db_name
  resource_group_name = azurerm_resource_group.main.name
  server_name        = azurerm_mysql_flexible_server.main.name
  charset            = "utf8mb4"
  collation          = "utf8mb4_general_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name        = azurerm_mysql_flexible_server.main.name
  start_ip_address   = "0.0.0.0"
  end_ip_address     = "0.0.0.0"
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.main.name
  server_name        = azurerm_mysql_flexible_server.main.name
  value              = "ON"
}

resource "azurerm_mysql_flexible_server_configuration" "tls_version" {
  name                = "tls_version"
  resource_group_name = azurerm_resource_group.main.name
  server_name        = azurerm_mysql_flexible_server.main.name
  value              = "TLSv1.2,TLSv1.3"
}