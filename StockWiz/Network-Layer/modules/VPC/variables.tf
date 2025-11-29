variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}