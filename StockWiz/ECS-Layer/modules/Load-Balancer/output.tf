# Generated with AI
output "alb_target_groups_arn" {
  description = "ALB Target Groups ARN mapped by environment"
  value       = { for env, tg in aws_lb_target_group.alb_tg : env => tg.arn }
}

output "alb_dns_name" {
  description = "ALB DNS name mapped by environment"
  value       = { for env, lb in aws_lb.alb : env => lb.dns_name }
}

output "alb_arn" {
  description = "ALB ARN mapped by environment"
  value       = { for env, lb in aws_lb.alb : env => lb.arn }
}

output "product_tg_arn" {
  description = "Product target group ARN mapped by environment"
  value       = { for env, tg in aws_lb_target_group.product_tg : env => tg.arn }
}

output "inventory_tg_arn" {
  description = "Inventory target group ARN mapped by environment"
  value       = { for env, tg in aws_lb_target_group.inventory_tg : env => tg.arn }
}