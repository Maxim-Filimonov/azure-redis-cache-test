#!/bin/bash

# Azure Redis Cache Test Cleanup Script
# This script removes all Azure resources created by Terraform

set -e

echo "🗑️  Cleaning up Azure resources using Terraform..."

# Check if Terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    echo "⚠️  No terraform.tfstate file found. Nothing to destroy."
    echo "   If resources were created manually, you may need to delete them via Azure CLI or portal."
    exit 0
fi

# Destroy resources using Terraform
terraform destroy -auto-approve

echo "✅ All Terraform-managed resources have been destroyed."