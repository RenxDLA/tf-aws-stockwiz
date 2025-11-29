
# Rol del laboratorio
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tfstate-ob290199"
    key    = "network-layer/terraform.tfstate"
    region = "us-east-1"
  }
}

# Discover the Network VPC using tags (app name). Generated with AI
data "aws_vpc" "network_vpc" {
  filter {
    name = "tag:Name"
    values = ["${lower(var.app_name)}-vpc"]
  }
}

# Discover public subnets by tag Type=public and the VPC ID. Generated with AI
data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name = "tag:Type"
    values = ["public"]
  }
}

