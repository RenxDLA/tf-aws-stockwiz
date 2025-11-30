# Generated with AI
output "alb_target_groups_arn" {
  description = "ALB Target Groups ARN mapped by environment"
  value       = { for env, tg in aws_lb_target_group.alb_tg : env => tg.arn }
}