# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Headless WordPress on Azure App Service with Next.js frontend

WordPress on App Service reference:
https://github.com/Azure/wordpress-linux-appservice/tree/main/Terraform_Script_Create_WP

Architecture:
- WordPress Backend: Azure App Service (Linux) with PHP 8.2
- Database: Azure Database for MySQL (Flexible Server)
- Frontend: Next.js on Azure Static Web Apps (SSG-focused)
- Infrastructure: Terraform for IaC

## Development Commands

```bash
# Install dependencies (missing Tailwind CSS dependencies need to be added)
npm install

# Development server
npm run dev

# Build static site
npm run build

# Lint code
npm run lint

# Deploy infrastructure
cd terraform
terraform init
terraform plan
terraform apply
```

Note: No test commands available - testing framework not configured

## Key Implementation Requirements

1. **Preview Functionality**: Implement headless WordPress preview feature in Next.js (not yet implemented)
2. **Security Architecture**: 
   - SWA API functions act only as relay
   - VNET-integrated Azure Functions handle WordPress communication
   - WordPress security must be maintained through network isolation

## Code Architecture

todo
## Important Notes

- Missing dependencies: Tailwind CSS and @tailwindcss/typography are used but not in package.json
- TypeScript strict mode is disabled
- No CI/CD workflows despite README mentioning GitHub Actions
- Azure Functions integration mentioned but not implemented
- Preview functionality requirement not yet addressed