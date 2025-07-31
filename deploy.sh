#!/bin/bash

# Azure Redis Cache Test Deployment Script
# This script creates all the necessary Azure resources and deploys the application

set -e

# Configuration
RESOURCE_GROUP="redis-cache-test-rg"
LOCATION="australiasoutheast"
REDIS_NAME="redis-cache-test-$(date +%s)"
APP_NAME="redis-cache-test-app-$(date +%s)"
APP_SERVICE_PLAN="redis-cache-test-plan"

echo "🚀 Starting deployment..."
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo "Redis Cache: $REDIS_NAME"
echo "App Service: $APP_NAME"

# Create resource group
echo "📦 Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Redis Cache
echo "🔴 Creating Redis Cache..."
az redis create \
  --name $REDIS_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Basic \
  --vm-size c0

# Create App Service Plan (Linux)
echo "📱 Creating App Service Plan..."
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --is-linux \
  --sku F1

# Create Web App
echo "🌐 Creating Web App..."
az webapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --runtime "NODE:22-lts"

# Get Redis connection info
echo "🔑 Getting Redis connection details..."
REDIS_HOSTNAME=$(az redis show --name $REDIS_NAME --resource-group $RESOURCE_GROUP --query "hostName" -o tsv)
REDIS_ACCESS_KEY=$(az redis list-keys --name $REDIS_NAME --resource-group $RESOURCE_GROUP --query "primaryKey" -o tsv)
REDIS_URL="rediss://$REDIS_HOSTNAME:6380"

# Configure App Settings
echo "⚙️  Configuring App Settings..."
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    REDIS_URL="$REDIS_URL" \
    REDIS_ACCESS_KEY="$REDIS_ACCESS_KEY"

# Deploy application
echo "🚢 Deploying application..."
cd app
az webapp up \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --runtime "NODE:22-lts" \
  --sku F1

echo ""
echo "✅ Deployment completed successfully!"
echo ""
echo "🔗 Application URL: https://$APP_NAME.azurewebsites.net"
echo "🔗 Health Check: https://$APP_NAME.azurewebsites.net/health"
echo ""
echo "Test endpoints:"
echo "  GET  /                    - Application status"
echo "  GET  /health              - Health check with Redis ping"
echo "  GET  /set/key/value       - Set a key-value pair in Redis"
echo "  GET  /get/key             - Get a value from Redis"
echo ""
echo "Example usage:"
echo "  curl https://$APP_NAME.azurewebsites.net/set/test/hello"
echo "  curl https://$APP_NAME.azurewebsites.net/get/test"