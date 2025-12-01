resource "aws_db_instance" "db" {
  for_each = toset(var.environment_to_deploy)

  db_name                 = lower("${var.app_name}-db-${each.key}")
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group[each.key].name
  vpc_security_group_ids  = var.security_group_ids[each.key]
  skip_final_snapshot     = true
  backup_retention_period = 7
  tags = {
    Name        = lower("${var.app_name}-db-${each.key}")
    Creator     = "Terraform"
    Environment = each.key
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  for_each   = toset(var.environment_to_deploy)
  name       = lower("${var.app_name}-db-subnet-${each.key}")
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = lower("${var.app_name}-db-subnet-${each.key}")
    Creator = "Terraform"
  }
}
