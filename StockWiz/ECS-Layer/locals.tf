# Created with AI
locals {
  # Constructs PostgreSQL database connection strings for multiple environments
  # Creates a map where each key is an environment and value is a fully-formed connection URL
  # Used by application services to connect to their respective environment's database
  database_urls = { for k in toset(var.environment_to_deploy) : k => "postgres://${var.db_username}:${var.db_password}@${module.rds.db_address[k]}:${module.rds.db_port[k]}/${module.rds.db_name[k]}" }
  # Builds Redis connection strings for multiple environments
  # Creates a map where each key is an environment and value is a Redis connection URL
  # Used by application services for caching and session storage per environment
  redis_urls = { for k in toset(var.environment_to_deploy) : k => "redis://${module.redis.redis_primary_endpoint_address[k]}:${module.redis.redis_primary_port[k]}" }
  # Redis addresses without scheme for Go-based services (host:port)
  redis_addrs = { for k in toset(var.environment_to_deploy) : k => "${module.redis.redis_primary_endpoint_address[k]}:${module.redis.redis_primary_port[k]}" }
}
