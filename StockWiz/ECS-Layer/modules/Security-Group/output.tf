output "alb_sg_ids" {
  description = "Application Load Balancer Security Group IDs"
  value = values(aws_security_group.alb_sg)[*].id
}