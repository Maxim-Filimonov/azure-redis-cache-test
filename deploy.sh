#!/bin/bash

# Azure Redis Cache Test Deployment Script
# This script uses Terraform to create Azure resources and deploys the application

set -e

echo "🚀 Starting Terraform deployment..."

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Plan the deployment
echo "📋 Planning Terraform deployment..."
terraform plan

# Apply the deployment
echo "🚀 Applying Terraform configuration..."
terraform apply -auto-approve

# Get outputs from Terraform
echo "📝 Getting Terraform outputs..."
APP_NAME=$(terraform output -raw app_service_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
APP_SERVICE_PLAN=$(terraform output -raw app_service_plan_name)

echo "Retrieved values:"
echo "  App Name: $APP_NAME"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  App Service Plan: $APP_SERVICE_PLAN"

# Deploy application
echo "🚢 Deploying application..."
cd app
az webapp up \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --runtime "NODE:22-lts" \
  --sku F1
cd ..

echo ""
echo "✅ Deployment completed successfully!"
echo ""

# Display Terraform outputs
echo "🔗 Application URL: $(terraform output -raw application_url)"
echo "🔗 Health Check: $(terraform output -raw health_check_url)"
echo ""
echo "Test endpoints:"
echo "  GET  /                    - Application status"
echo "  GET  /health              - Health check with Redis ping"
echo "  GET  /set/key/value       - Set a key-value pair in Redis"
echo "  GET  /get/key             - Get a value from Redis"
echo ""
echo "Example usage:"
echo "  curl $(terraform output -raw application_url)/set/test/hello"
echo "  curl $(terraform output -raw application_url)/get/test"
