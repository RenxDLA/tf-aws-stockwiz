output "alb_sg_ids" {
  description = "Application Load Balancer Security Group IDs"
  value = values(aws_security_group.alb_sg)[*].id
}

output "ecs_tasks_sg_ids" {
  description = "ECS Tasks Security Group IDs"
  value = values(aws_security_group.ecs_tasks_sg)[*].id
}