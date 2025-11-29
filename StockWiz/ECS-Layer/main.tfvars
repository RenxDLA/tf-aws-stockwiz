environment           = "Main"
environment_to_deploy = ["Prod"]
aws_region            = "us-east-1"
app_name              = "StockWiz"

# Security Group Variables
ingress = {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# Load Balancer Variables
lb_type        = "application"
lb_tg_protocol = "HTTP"
lb_tg_port     = 80
lb_tg_type     = "ip"

lb_health_check = {
  healthy_threshold   = 2
  interval            = 30
  matcher             = "200"
  path                = "/"
  port                = "traffic-port"
  protocol            = "HTTP"
  timeout             = 5
  unhealthy_threshold = 2
}

lb_listener_port        = 80
lb_listener_protocol    = "HTTP"
lb_listener_action_type = "forward"

