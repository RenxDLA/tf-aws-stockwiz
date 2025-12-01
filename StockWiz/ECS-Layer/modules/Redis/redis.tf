resource "aws_elasticache_replication_group" "redis" {
  for_each = toset(var.environment_to_deploy)

  replication_group_id       = lower("${var.app_name}-redis-${each.key}")
  description                = "Redis replication group for ${var.app_name} in ${each.key} environment"
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_nodes
  port                       = var.redis_port
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group[each.key].name
  security_group_ids         = var.security_group_ids[each.key]
  automatic_failover_enabled = false

  tags = {
    Name        = lower("${var.app_name}-redis-${each.key}")
    Creator     = "Terraform"
    Environment = each.key
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  for_each = toset(var.environment_to_deploy)

  name       = lower("${var.app_name}-redis-subnet-${each.key}")
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = lower("${var.app_name}-redis-subnet-${each.key}")
    Creator = "Terraform"
  }
}
