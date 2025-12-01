
# Rol del laboratorio
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Discover the Network VPC using tags (app name). Generated with AI
data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${lower(var.app_name)}-vpc"]
  }
}

# Discover public subnets by tag Type=public and the VPC ID. Generated with AI
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

# Discover private subnets by tag Type=private and the VPC ID
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_ecr_repository" "ecr_url" {
  name = lower("${var.app_name}-ecr-repo")
}
