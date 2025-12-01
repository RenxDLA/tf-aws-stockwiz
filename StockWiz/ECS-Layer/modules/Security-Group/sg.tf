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

resource "aws_security_group" "ecs_tasks_sg" {
  for_each    = toset(var.environment_to_deploy)
  name        = lower("${var.app_name}-ecs-tasks-sg-${each.key}")
  description = "Security group for ECS Tasks in ${each.key} environment"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.task_ingress
    content {
      description     = lookup(ingress.value, "description", "Allow traffic from ALB")
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
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

resource "aws_security_group" "db_sg" {
  for_each = toset(var.environment_to_deploy)

  name        = lower("${var.app_name}-db-sg-${each.key}")
  description = "Security group for DB in ${each.key}"
  vpc_id      = var.vpc_id

  # Allow inbound from VPC (CIDR) as a fallback; we'll add more secure rule from ECS layer later
  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }

  tags = {
    Name        = lower("${var.app_name}-db-sg-${each.key}")
    Creator     = "Terraform"
    Environment = each.key
  }
}

resource "aws_security_group_rule" "allow_ecs_to_db" {
  for_each = toset(var.environment_to_deploy)

  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg[each.key].id
  source_security_group_id = aws_security_group.ecs_tasks_sg[each.key].id
}

resource "aws_security_group" "redis_sg" {
  for_each    = toset(var.environment_to_deploy)
  name        = lower("${var.app_name}-redis-sg-${each.key}")
  description = "Security group for Redis ${each.key}"
  vpc_id      = var.vpc_id

  # Allow inbound from everywhere as a fallback; will be tightened using ECS layer rules
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }

  tags = {
    Name        = lower("${var.app_name}-redis-sg-${each.key}")
    Creator     = "Terraform"
    Environment = each.key
  }
}

resource "aws_security_group_rule" "allow_ecs_to_redis" {
  for_each                 = toset(var.environment_to_deploy)
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis_sg[each.key].id
  source_security_group_id = aws_security_group.ecs_tasks_sg[each.key].id
}


