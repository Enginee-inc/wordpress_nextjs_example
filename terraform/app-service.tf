resource "random_password" "auth_key" {
  length  = 64
  special = true
}

resource "random_password" "secure_auth_key" {
  length  = 64
  special = true
}

resource "random_password" "logged_in_key" {
  length  = 64
  special = true
}

resource "random_password" "nonce_key" {
  length  = 64
  special = true
}

resource "random_password" "auth_salt" {
  length  = 64
  special = true
}

resource "random_password" "secure_auth_salt" {
  length  = 64
  special = true
}

resource "random_password" "logged_in_salt" {
  length  = 64
  special = true
}

resource "random_password" "nonce_salt" {
  length  = 64
  special = true
}

resource "azurerm_linux_web_app" "wordpress" {
  name                = "${var.prefix}-wordpress"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  service_plan_id    = azurerm_service_plan.main.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
    
    always_on = false
  }

  app_settings = {
    "MYSQL_HOSTNAME"     = azurerm_mysql_flexible_server.main.fqdn
    "MYSQL_DATABASE"     = azurerm_mysql_flexible_database.wordpress.name
    "MYSQL_USERNAME"     = "${var.mysql_admin_username}@${azurerm_mysql_flexible_server.main.name}"
    "MYSQL_PASSWORD"     = var.mysql_admin_password
    "WORDPRESS_DB_HOST"  = azurerm_mysql_flexible_server.main.fqdn
    "WORDPRESS_DB_NAME"  = azurerm_mysql_flexible_database.wordpress.name
    "WORDPRESS_DB_USER"  = "${var.mysql_admin_username}@${azurerm_mysql_flexible_server.main.name}"
    "WORDPRESS_DB_PASSWORD" = var.mysql_admin_password
    "WP_DEBUG"          = "false"
    "WP_DEBUG_LOG"      = "false"
    "WORDPRESS_AUTH_KEY" = random_password.auth_key.result
    "WORDPRESS_SECURE_AUTH_KEY" = random_password.secure_auth_key.result
    "WORDPRESS_LOGGED_IN_KEY" = random_password.logged_in_key.result
    "WORDPRESS_NONCE_KEY" = random_password.nonce_key.result
    "WORDPRESS_AUTH_SALT" = random_password.auth_salt.result
    "WORDPRESS_SECURE_AUTH_SALT" = random_password.secure_auth_salt.result
    "WORDPRESS_LOGGED_IN_SALT" = random_password.logged_in_salt.result
    "WORDPRESS_NONCE_SALT" = random_password.nonce_salt.result
    "WORDPRESS_HOME_URL" = "https://${azurerm_linux_web_app.wordpress.default_hostname}"
    "WORDPRESS_BLOCK_EXTERNAL_URL_ACCESS" = "true"
    "WORDPRESS_HIDE_ADMIN" = "true"
    "WORDPRESS_ADMIN_PATH" = "secure-admin"
    "WORDPRESS_COOKIE_DOMAIN" = azurerm_linux_web_app.wordpress.default_hostname
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "MySQL"
    value = "Server=${azurerm_mysql_flexible_server.main.fqdn};Database=${azurerm_mysql_flexible_database.wordpress.name};Uid=${var.mysql_admin_username}@${azurerm_mysql_flexible_server.main.name};Pwd=${var.mysql_admin_password};"
  }
}