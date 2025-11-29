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

