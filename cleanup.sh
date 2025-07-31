#!/bin/bash

# Azure Redis Cache Test Cleanup Script
# This script removes all Azure resources created by the deployment

set -e

RESOURCE_GROUP="redis-cache-test-rg"

echo "🗑️  Cleaning up Azure resources..."
echo "Resource Group: $RESOURCE_GROUP"

# Delete the entire resource group (this removes all resources within it)
az group delete --name $RESOURCE_GROUP --yes --no-wait

echo "✅ Cleanup initiated. Resources are being deleted in the background."
echo "   Use 'az group show --name $RESOURCE_GROUP' to check deletion status."