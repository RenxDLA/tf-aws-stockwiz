variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway Id"
  type        = string
}

variable "route_table_cidr_block" {
  description = "Route Table CIDR block"
  type = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  type        = list(string)
}