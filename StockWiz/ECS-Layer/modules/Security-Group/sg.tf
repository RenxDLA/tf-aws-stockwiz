resource "aws_security_group" "alb_sg" {
  for_each    = toset(var.environment_to_deploy)
  name        = lower("${var.app_name}-alb-sg-${each.key}")
  description = "Security group for Application Load Balancer in ${each.key} environment"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.ingress.from_port
    to_port     = var.ingress.to_port
    protocol    = var.ingress.protocol
    cidr_blocks = var.ingress.cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }

  tags = {
    Name        = lower("${var.app_name}-alb-sg-${each.key}")
    Environment = each.key
    Creator     = "Terraform"
  }
}

