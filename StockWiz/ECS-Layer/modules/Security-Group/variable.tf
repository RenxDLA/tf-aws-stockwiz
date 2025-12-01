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

variable "ingress" {
  description = "List of ingress rules for security group"
  type = object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  })
}

variable "task_ingress" {
  description = "Ingress rules to open on ECS tasks SG "
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

variable "db_port" {
  type = number
}
