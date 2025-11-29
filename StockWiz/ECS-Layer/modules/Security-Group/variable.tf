variable "environment_to_deploy" {
  description = "List of environments to deploy"
  type        = list(string)
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_id"{
  description = "VPC ID"
  type        = string
}

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
