resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.app_name}-igw"
    Creator     = "Terraform"
  }
}
