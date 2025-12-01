output "alb_sg_ids" {
  description = "Application Load Balancer Security Group IDs"
  value       = values(aws_security_group.alb_sg)[*].id
}

output "ecs_tasks_sg_ids" {
  description = "ECS Tasks Security Group IDs"
  value       = values(aws_security_group.ecs_tasks_sg)[*].id
}

output "db_sg_ids" {
  description = "DB Security Group IDs mapped by environment"
  value       = { for k, sg in aws_security_group.db_sg : k => [sg.id] }
}

output "redis_sg_ids" {
  description = "Redis Security Group IDs mapped by environment"
  value       = { for k, sg in aws_security_group.redis_sg : k => [sg.id] }
}
