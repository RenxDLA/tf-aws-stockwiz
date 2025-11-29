resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name    = "${var.app_name}-public-rt"
    Creator = "Terraform"
  }
}

resource "aws_route_table_association" "public_association" {
  count     = length(var.public_subnet_ids)
  subnet_id = var.public_subnet_ids[count.index]
  # subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = aws_route_table.public.id
}
