# Headless WordPress + Next.js on Azure

This project sets up a headless WordPress backend on Azure App Service with a Next.js frontend on Azure Static Web Apps, all managed with Terraform.

## Architecture

- **WordPress Backend**: Azure App Service (Linux) with PHP 8.2
- **Database**: Azure Database for MySQL (Flexible Server)
- **Next.js Frontend**: Azure Static Web Apps
- **Infrastructure**: Terraform for Infrastructure as Code

## Prerequisites

- Azure CLI installed and configured
- Terraform installed
- Node.js 18+ installed
- Git repository for deployment

## Quick Start

### 1. Deploy Infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

### 2. Configure GitHub Secrets

Add these secrets to your GitHub repository:

- `AZURE_STATIC_WEB_APPS_API_TOKEN`: From Terraform output
- `AZURE_WEBAPP_NAME`: WordPress app service name
- `AZURE_WEBAPP_PUBLISH_PROFILE`: Download from Azure Portal
- `WORDPRESS_API_URL`: Your WordPress REST API URL

### 3. Deploy Applications

Push to main branch to trigger deployments:
- WordPress will deploy to Azure App Service
- Next.js will deploy to Azure Static Web Apps

## WordPress Setup

After deployment, visit your WordPress site and complete the installation:

1. Go to `https://your-wordpress-site.azurewebsites.net`
2. Complete WordPress installation
3. Install recommended plugins:
   - WP CORS (for cross-origin requests)

## Development

### Local Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

### Environment Variables

Create `.env.local` for local development:

```env
WORDPRESS_API_URL=https://your-wordpress-site.azurewebsites.net/wp-json/wp/v2
```

## Project Structure

```
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # Main Terraform config
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output values
│   ├── mysql.tf           # MySQL database
│   ├── app-service.tf     # WordPress App Service
│   └── static-web-app.tf  # Next.js Static Web App
├── wordpress/              # WordPress theme and config
│   ├── wp-config.php      # WordPress configuration
│   ├── functions.php      # Theme functions
│   ├── style.css          # Theme styles
│   └── index.php          # Theme template
├── app/                   # Next.js application
├── lib/                   # Utility functions
├── .github/workflows/     # CI/CD pipelines
└── package.json           # Node.js dependencies
```

## Features

- **Headless Architecture**: WordPress as a content management system with Next.js frontend
- **Azure Integration**: Fully integrated with Azure services
- **REST API**: WordPress REST API for data fetching
- **Responsive Design**: Mobile-first design with Tailwind CSS
- **Static Generation**: Fast performance with Next.js static generation
- **CI/CD**: Automated deployments with GitHub Actions
- **Infrastructure as Code**: Reproducible infrastructure with Terraform

## Customization

### WordPress

- Edit `wordpress/functions.php` to customize WordPress functionality
- Modify `wordpress/wp-config.php` for WordPress configuration
- Add custom themes in the `wordpress/` directory

### Next.js

- Customize the design in `app/globals.css`
- Add new pages in the `app/` directory
- Modify API calls in `lib/wordpress.ts`

## Troubleshooting

### Common Issues

1. **CORS Errors**: Install and configure WP CORS plugin in WordPress
2. **Database Connection**: Check MySQL credentials in Terraform variables
3. **Static Web App Deployment**: Verify GitHub secrets are set correctly
4. **WordPress Installation**: Ensure MySQL database is accessible

### Logs

- WordPress logs: Azure App Service logs
- Next.js logs: GitHub Actions logs
- Infrastructure logs: Terraform output

## Security

- Database credentials are managed through Azure Key Vault integration
- HTTPS is enforced on all endpoints
- CORS is properly configured for cross-origin requests
- WordPress file editing is disabled in production

## Cost Optimization

- Uses Azure Free tier where possible
- MySQL Flexible Server B1s for development
- Static Web Apps free tier for Next.js hosting
- Consider scaling up for production workloads

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review Azure service logs
3. Verify Terraform configuration
4. Check GitHub Actions workflow logs