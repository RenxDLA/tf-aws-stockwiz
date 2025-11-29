resource "aws_lb" "alb" {
  for_each           = toset(var.environment_to_deploy)
  name               = lower("${var.app_name}-lb-${each.key}")
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = var.lb_security_group_ids
  subnets            = var.public_subnet_ids

  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-lb-${each.key}")
    Creator     = "Terraform"
    Type        = "Application Load Balancer"
  }

}

resource "aws_lb_target_group" "alb_tg" {
  for_each    = toset(var.environment_to_deploy)
  name        = lower("${var.app_name}-tg-${each.key}")
  port        = var.lb_tg_port
  protocol    = var.lb_tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.lb_tg_type

  health_check {
    enabled             = true
    healthy_threshold   = var.lb_health_check.healthy_threshold
    interval            = var.lb_health_check.interval
    matcher             = var.lb_health_check.matcher
    path                = var.lb_health_check.path
    port                = var.lb_health_check.port
    protocol            = var.lb_health_check.protocol
    timeout             = var.lb_health_check.timeout
    unhealthy_threshold = var.lb_health_check.unhealthy_threshold
  }

  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-tg-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_lb_listener" "alb_listener" {
  for_each          = toset(var.environment_to_deploy)
  load_balancer_arn = aws_lb.alb[each.key].arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_listener_action_type
    target_group_arn = aws_lb_target_group.alb_tg[each.key].arn
  }

  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-alb-listener-${each.key}")
    Creator     = "Terraform"
  }
}
