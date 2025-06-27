resource "azurerm_storage_account" "wordpress_files" {
  name                     = "${replace(var.prefix, "-", "")}wpstorage"
  resource_group_name      = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "wordpress_content" {
  name                  = "wordpress"
  storage_account_id  = azurerm_storage_account.wordpress_files.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "wp_config" {
  name                   = "wp-config.php"
  storage_account_name   = azurerm_storage_account.wordpress_files.name
  storage_container_name = azurerm_storage_container.wordpress_content.name
  type                   = "Block"
  source                 = "../wordpress/wp-config.php"
}

resource "azurerm_storage_blob" "htaccess" {
  name                   = ".htaccess"
  storage_account_name   = azurerm_storage_account.wordpress_files.name
  storage_container_name = azurerm_storage_container.wordpress_content.name
  type                   = "Block"
  source                 = "../wordpress/.htaccess"
}

resource "azurerm_storage_blob" "index_php" {
  name                   = "index.php"
  storage_account_name   = azurerm_storage_account.wordpress_files.name
  storage_container_name = azurerm_storage_container.wordpress_content.name
  type                   = "Block"
  source                 = "../wordpress/index.php"
}

resource "azurerm_storage_blob" "functions_php" {
  name                   = "functions.php"
  storage_account_name   = azurerm_storage_account.wordpress_files.name
  storage_container_name = azurerm_storage_container.wordpress_content.name
  type                   = "Block"
  source                 = "../wordpress/functions.php"
}

# WordPress core installation via Azure CLI extension
resource "null_resource" "wordpress_install" {
  depends_on = [
    azurerm_linux_web_app.wordpress,
    azurerm_mysql_flexible_database.wordpress,
    azurerm_storage_blob.wp_config
  ]

  provisioner "local-exec" {
    command = <<-EOT
      # Install WordPress core files
      curl -O https://wordpress.org/latest.tar.gz
      tar -xzf latest.tar.gz
      
      # Upload WordPress files to App Service
      az webapp deployment source config-zip \
        --resource-group ${azurerm_resource_group.main.name} \
        --name ${azurerm_linux_web_app.wordpress.name} \
        --src wordpress.zip
      
      # Set deployment credentials
      az webapp deployment user set \
        --user-name ${var.deployment_username} \
        --password ${var.deployment_password}
      
      # Create wordpress.zip
      cd wordpress
      zip -r ../wordpress.zip .
      cd ..
      
      # Clean up
      rm -rf wordpress latest.tar.gz
    EOT
  }

  triggers = {
    wordpress_app_id = azurerm_linux_web_app.wordpress.id
  }
}

# Configure WordPress after installation
resource "null_resource" "wordpress_configure" {
  depends_on = [null_resource.wordpress_install]

  provisioner "local-exec" {
    command = <<-EOT
      # Wait for WordPress to be ready
      sleep 30
      
      # Run WordPress CLI commands via SSH
      az webapp ssh --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_linux_web_app.wordpress.name} --command "
        cd /home/site/wwwroot
        
        # Download WP-CLI
        curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/phar/wp-cli.phar
        chmod +x wp-cli.phar
        
        # Install WordPress core
        php wp-cli.phar core install \
          --url='https://${azurerm_linux_web_app.wordpress.default_hostname}' \
          --title='${var.wordpress_site_title}' \
          --admin_user='${var.wordpress_admin_user}' \
          --admin_password='${var.wordpress_admin_password}' \
          --admin_email='${var.wordpress_admin_email}' \
          --skip-email
        
        # Install security plugins
        php wp-cli.phar plugin install wordfence --activate
        php wp-cli.phar plugin install limit-login-attempts-reloaded --activate
        
        # Update permalinks
        php wp-cli.phar rewrite structure '/%postname%/'
        php wp-cli.phar rewrite flush
        
        # Remove default themes/plugins
        php wp-cli.phar theme delete twentytwentyone twentytwentytwo
        php wp-cli.phar plugin delete hello akismet
      "
    EOT
  }

  triggers = {
    wordpress_install_id = null_resource.wordpress_install.id
  }
}