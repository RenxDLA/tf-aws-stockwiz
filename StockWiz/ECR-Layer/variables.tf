variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "image_tag_mutability" {
  description = "ECR Image Tag Mutability"
  type        = string
}