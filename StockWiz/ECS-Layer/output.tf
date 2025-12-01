output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_name
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_arn
}

#Generated with AI
output "ecs_product_service_name"{
  description = "The name of the ECS product service"
  value       = module.ecs_cluster.ecs_product_service_name
}

output "ecs_inventory_service_name"{
  description = "The name of the ECS inventory service"
  value       = module.ecs_cluster.ecs_inventory_service_name
}

output "ecs_api_service_name"{
  description = "The name of the ECS API Gateway service"
  value       = module.ecs_cluster.ecs_api_service_name
}

output "alb_dns_name" {
  description = "ALB DNS name for each environment"
  value       = module.load_balancer.alb_dns_name
}