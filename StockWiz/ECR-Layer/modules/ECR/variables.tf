variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "image_tag_mutability" {
  description = "ECR Image Tag Mutability"
  type        = string
}
