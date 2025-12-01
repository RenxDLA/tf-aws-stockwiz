variable "environment" {
  description = "Deployment environment (e.g. stream, main)"
  type        = string
}

variable "environment_to_deploy" {
  description = "List of environments to deploy"
  type        = list(string)
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of Security Group IDs"
  type        = list(string)
}

variable "alb_target_groups_arn" {
  description = "ALB Target Groups ARN mapped by environment"
  type        = map(string)
}

variable "service_launch_type" {
  description = "ECS services launch type"
  type        = string
}

variable "task_network_mode" {
  description = "ECS Tasks Network Mode"
  type        = string
}

variable "task_execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  type        = string
}

variable "aws_region" {
  description = "AWS Region for log group / settings"
  type        = string
}

variable "task_product" {
  description = "ECS Task for Product Service"
  type = object({
    cpu    = number
    memory = number
  })
}

variable "task_product_container" {
  description = "Container definition for Product Service"
  type = object({
    container_port = number
    host_port      = number
    protocol       = string
  })
}

variable "task_inventory" {
  description = "ECS Task for Inventory Service"
  type = object({
    cpu    = number
    memory = number
  })
}

variable "task_inventory_container" {
  description = "Container definition for Inventory Service"
  type = object({
    container_port = number
    host_port      = number
    protocol       = string
  })
}

variable "task_api" {
  description = "ECS Task for API Gateway Service"
  type = object({
    cpu    = number
    memory = number
  })
}

variable "task_api_container" {
  description = "Container definition for API Gateway Service"
  type = object({
    container_port = number
    host_port      = number
    protocol       = string
  })
}

variable "product_service_count" {
  description = "Desired count of ECS product service"
  type        = number
}

variable "inventory_service_count" {
  description = "Desired count of ECS inventory service"
  type        = number
}

variable "api_service_count" {
  description = "Desired count of ECS API gateway service"
  type        = number
}

variable "ecr_url" {
  description = "URL from ECR"
  type        = string
}

variable "database_url" {
  description = "Database connection URL per environment"
  type        = map(string)
}

variable "redis_url" {
  description = "Redis connection URL per environment"
  type        = map(string)
}

variable "redis_addr" {
  description = "Redis address (host:port) per environment for Go services that don't accept URL scheme"
  type        = map(string)
}

variable "alb_dns_name" {
  description = "ALB dns names mapped by env (from Load Balancer module)"
  type        = map(string)
  default     = {}
}

variable "target_group_path_prefix_product" {
  description = "Path prefix for product API to route via ALB (fallback)"
  type        = string
}

variable "target_group_path_prefix_inventory" {
  description = "Path prefix for inventory API to route via ALB (fallback)"
  type        = string
}

variable "inventory_tg_arn" {
  description = "Inventory service ALB Target Group ARN mapped by environment"
  type        = map(string)
  
}

variable "product_tg_arn" {
  description = "Product service ALB Target Group ARN mapped by environment"
  type        = map(string)
  
}


