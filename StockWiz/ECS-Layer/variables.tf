variable "environment" {
  description = "Deployment environment (e.g. stream, main)"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_to_deploy" {
  description = "List of environments to deploy"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

# Security Group Variables

variable "ingress" {
  description = "Ingress rules for security group"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}

variable "task_ingress" {
  description = "Ingress rules for ECS tasks security group (from the ALB SG)"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
}

variable "egress" {
  description = "Egress rules for security group"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}

# Load Balancer Variables
variable "lb_type" {
  description = "Type of Load Balancer"
  type        = string
}

variable "lb_tg_protocol" {
  description = "Load Balancer Target Group Protocol"
  type        = string
}

variable "lb_tg_port" {
  description = "Load Balancer Target Group Port"
  type        = number
}

variable "lb_tg_type" {
  description = "Load Balancer Target Group Type"
  type        = string
}

# Load Balancer Health Check Variables
variable "lb_health_check" {
  description = "Load Balancer Health Check"
  type = object({
    healthy_threshold   = number
    interval            = number
    matcher             = number
    path                = string
    port                = string
    protocol            = string
    timeout             = number
    unhealthy_threshold = number
  })
}

# Load Balancer Listener Variables
variable "lb_listener_port" {
  description = "Load Balancer Listener Port"
  type        = number
}

variable "lb_listener_protocol" {
  description = "Load Balancer Listener Protocol"
  type        = string
}

variable "lb_listener_action_type" {
  description = "Load Balancer Listener Action Type"
  type        = string
}

# ECS Variables

variable "service_launch_type" {
  description = "ECS services launch type"
  type        = string
}

variable "task_network_mode" {
  description = "ECS Tasks Network Mode"
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

# DB variables
variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type    = string
}

variable "allocated_storage" {
  type    = number
}

variable "engine" {
  type    = string
}

variable "engine_version" {
  type    = string
}

variable "db_port" {
  type    = number
}

# Redis variables
variable "node_type" {
  description = "Redis node type"
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
}
