output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_name
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_arn
}

output "ecs_api_service_name"{
  description = "The name of the ECS API Gateway service"
  value       = module.ecs_cluster.ecs_api_service_name
}

output "alb_dns_name" {
  description = "ALB DNS name for each environment"
  value       = module.load_balancer.alb_dns_name
}

output "db_address" {
  description = "The address of the RDS instance for each environment"
  value       = module.rds.db_address
}

output "db_endpoint" {
  description = "The connection endpoint (address:port) for each environment"
  value       = module.rds.db_endpoint
}

output "db_name" {
  description = "The database name for each environment"
  value       = module.rds.db_name
}

output "db_port" {
  description = "The port the database is listening on for each environment"
  value       = module.rds.db_port
}