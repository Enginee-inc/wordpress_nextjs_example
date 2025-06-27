# Secure WordPress Terraform Configuration
# Copy this file to terraform.tfvars and fill in your values

# Basic Configuration
resource_group_name = "rg-secure-wordpress"
location           = "East US"
prefix             = "secure-wp"

# Database Configuration - Use strong passwords
mysql_admin_username = "securewpadmin"
mysql_admin_password = "your-very-strong-mysql-password-here"
wordpress_db_name   = "securewordpress"

# WordPress Admin Configuration - Use strong credentials
wordpress_site_title      = "Secure WordPress Site"
wordpress_admin_user      = "secureadmin"
wordpress_admin_password  = "your-very-strong-wp-admin-password-here"
wordpress_admin_email     = "admin@yourdomain.com"

# Deployment Configuration
deployment_username = "deployuser"
deployment_password = "your-deployment-password-here"

# GitHub Configuration for Static Web App
github_repo_url = "https://github.com/yourusername/your-repo"

# Security Options
enable_application_gateway = false  # Set to true for enterprise-grade security

# Security Notes:
# 1. Use complex passwords with special characters, numbers, and mixed case
# 2. Consider using Azure Key Vault references instead of plain text passwords
# 3. Enable Application Gateway for DDoS protection and advanced security
# 4. Regularly rotate passwords and keys
# 5. Monitor logs and set up alerts for suspicious activities