output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.arn
}

# #Generated with AI
# output "ecs_product_service_name" {
#   description = "The name of the ECS product service"
#   value       = { for env, svc in aws_ecs_service.ecs_product_service : env => svc.name }
# }

# output "ecs_inventory_service_name" {
#   description = "The name of the ECS inventory service"
#   value       = { for env, svc in aws_ecs_service.ecs_inventory_service : env => svc.name }
# }

output "ecs_api_service_name" {
  description = "The name of the ECS API Gateway service"
  value       = { for env, svc in aws_ecs_service.ecs_api_service : env => svc.name }
}
