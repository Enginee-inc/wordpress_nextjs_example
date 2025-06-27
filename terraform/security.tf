# Network Security Group for additional protection
resource "azurerm_network_security_group" "wordpress_nsg" {
  name                = "${var.prefix}-wordpress-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAll"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Key Vault for secure storage of secrets
resource "azurerm_key_vault" "wordpress_kv" {
  name                = "${replace(var.prefix, "-", "")}kv${random_id.kv_suffix.hex}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "random_id" "kv_suffix" {
  byte_length = 4
}

data "azurerm_client_config" "current" {}

# Store WordPress secrets in Key Vault
resource "azurerm_key_vault_secret" "wordpress_db_password" {
  name         = "wordpress-db-password"
  value        = var.mysql_admin_password
  key_vault_id = azurerm_key_vault.wordpress_kv.id
}

resource "azurerm_key_vault_secret" "wordpress_admin_password" {
  name         = "wordpress-admin-password"
  value        = var.wordpress_admin_password
  key_vault_id = azurerm_key_vault.wordpress_kv.id
}

resource "azurerm_key_vault_secret" "wordpress_auth_key" {
  name         = "wordpress-auth-key"
  value        = random_password.auth_key.result
  key_vault_id = azurerm_key_vault.wordpress_kv.id
}

# Web Application Firewall Policy
resource "azurerm_web_application_firewall_policy" "wordpress_waf" {
  name                = "${var.prefix}-waf-policy"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  policy_settings {
    enabled                     = true
    mode                       = "Prevention"
    request_body_check         = true
    file_upload_limit_in_mb    = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }

    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "0.1"
    }
  }

  custom_rules {
    name      = "BlockWordPressAttacks"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_values = [
        "wp-admin",
        "wp-login.php",
        "xmlrpc.php",
        ".php"
      ]
      operator           = "Contains"
      negation_condition = false
      
      match_variables {
        variable_name = "RequestUri"
      }
    }

    action = "Block"
  }

  custom_rules {
    name      = "AllowSecureAdmin"
    priority  = 2
    rule_type = "MatchRule"

    match_conditions {
      match_values = ["secure-admin"]
      operator           = "Contains"
      negation_condition = false
      
      match_variables {
        variable_name = "RequestUri"
      }
    }

    action = "Allow"
  }
}

# Application Gateway for WordPress (optional, for enterprise setups)
resource "azurerm_public_ip" "wordpress_agw_pip" {
  count               = var.enable_application_gateway ? 1 : 0
  name                = "${var.prefix}-agw-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "wordpress_vnet" {
  count               = var.enable_application_gateway ? 1 : 0
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "wordpress_agw_subnet" {
  count                = var.enable_application_gateway ? 1 : 0
  name                 = "${var.prefix}-agw-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.wordpress_vnet[0].name
  address_prefixes     = ["10.0.1.0/24"]
}

# Monitoring and logging
resource "azurerm_log_analytics_workspace" "wordpress_logs" {
  name                = "${var.prefix}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "wordpress_insights" {
  name                = "${var.prefix}-insights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.wordpress_logs.id
  application_type    = "web"
}