# Discover the Network VPC using tags (app name). Generated with AI
data "aws_vpc" "network_vpc" {
  filter {
    name = "tag:Name"
    values = ["${lower(var.app_name)}-vpc"]
  }
}