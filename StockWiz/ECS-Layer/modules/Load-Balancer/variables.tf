variable "environment_to_deploy" {
  description = "List of environments to deploy"
  type        = list(string)
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "lb_security_group_ids" {
  description = "Security Group IDs for the Load Balancer"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  type        = list(string)
}
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

variable "product_tg_port" {
  description = "Product service target group port"
  type        = number
  default     = 8001
}

variable "inventory_tg_port" {
  description = "Inventory service target group port"
  type        = number
  default     = 8002
}

variable "lb_tg_type" {
  description = "Load Balancer Target Group Type"
  type        = string
}

variable "target_group_path_prefix_product" {
  description = "Path prefix for product routing"
  type        = string
  default     = "/api/products"
}

variable "target_group_path_prefix_inventory" {
  description = "Path prefix for inventory routing"
  type        = string
  default     = "/api/inventory"
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
