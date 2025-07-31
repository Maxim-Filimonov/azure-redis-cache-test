terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  
  # Authentication will be handled by:
  # 1. Azure CLI (az login)
  # 2. Environment variables (ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, etc.)
  # 3. Managed Identity (when running on Azure)
  use_cli = true
}

# Generate random suffix for unique resource names
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Redis Cache
resource "azurerm_redis_cache" "main" {
  name                = "${var.redis_name}-${random_integer.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"

  tags = var.tags
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "F1"

  tags = var.tags
}

# Web App
resource "azurerm_linux_web_app" "main" {
  name                = "${var.app_name}-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false
    application_stack {
      node_version = "22-lts"
    }
  }

  app_settings = {
    REDIS_URL        = "rediss://${azurerm_redis_cache.main.hostname}:6380"
    REDIS_ACCESS_KEY = azurerm_redis_cache.main.primary_access_key
  }

  tags = var.tags
}