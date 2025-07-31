output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "redis_hostname" {
  description = "Redis cache hostname"
  value       = azurerm_redis_cache.main.hostname
}

output "redis_name" {
  description = "Redis cache name"
  value       = azurerm_redis_cache.main.name
}

output "redis_url" {
  description = "Redis connection URL"
  value       = "rediss://${azurerm_redis_cache.main.hostname}:6380"
  sensitive   = true
}

output "redis_access_key" {
  description = "Redis primary access key"
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}

output "app_service_name" {
  description = "Name of the created app service"
  value       = azurerm_linux_web_app.main.name
}

output "app_service_plan_name" {
  description = "Name of the created app service plan"
  value       = azurerm_service_plan.main.name
}

output "application_url" {
  description = "URL of the deployed application"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "health_check_url" {
  description = "Health check endpoint URL"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}/health"
}