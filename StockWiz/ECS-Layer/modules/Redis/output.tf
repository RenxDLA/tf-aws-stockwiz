output "redis_primary_endpoint_address" {
  description = "Redis primary endpoint address mapped by environment"
  value       = { for k, rg in aws_elasticache_replication_group.redis : k => rg.primary_endpoint_address }
}
