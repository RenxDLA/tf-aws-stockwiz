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

resource "aws_security_group" "ecs_tasks_sg"{
  for_each    = toset(var.environment_to_deploy)
  name        = lower("${var.app_name}-ecs-tasks-sg-${each.key}")
  description = "Security group for ECS Tasks in ${each.key} environment"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.task_ingress
    content {
      description = lookup(ingress.value, "description", "Allow traffic from ALB")
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      security_groups = [aws_security_group.alb_sg[each.key].id]
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }

  tags = {
    Name        = lower("${var.app_name}-ecs-tasks-sg-${each.key}")
    Environment = each.key
    Creator     = "Terraform"
  }
}

