variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "redis-cache-test-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "australiasoutheast"
}

variable "redis_name" {
  description = "Base name for the Redis cache (suffix will be added for uniqueness)"
  type        = string
  default     = "redis-cache-test"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "redis-cache-test-plan"
}

variable "app_name" {
  description = "Base name for the web app (suffix will be added for uniqueness)"
  type        = string
  default     = "redis-cache-test-app"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "test"
    Project     = "redis-cache-test"
  }
}