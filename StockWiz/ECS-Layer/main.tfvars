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
# lb_tg_port     = 8000
lb_tg_type = "ip"

lb_health_check = {
  healthy_threshold   = 2
  interval            = 30
  matcher             = "200"
  path                = "/health"
  port                = "traffic-port"
  protocol            = "HTTP"
  timeout             = 10
  unhealthy_threshold = 2
}

lb_listener_port        = 80
lb_listener_protocol    = "HTTP"
lb_listener_action_type = "forward"

# ECS Variables
service_launch_type = "FARGATE"
task_network_mode   = "awsvpc"
task_product = {
  cpu    = 256
  memory = 512
}
task_product_container = {
  container_port = 8001
  host_port      = 8001
  protocol       = "tcp"
}
task_inventory = {
  cpu    = 256
  memory = 512
}
task_inventory_container = {
  container_port = 8002
  host_port      = 8002
  protocol       = "tcp"
}
task_api = {
  cpu    = 256
  memory = 512
}
task_api_container = {
  container_port = 8000
  host_port      = 8000
  protocol       = "tcp"
}
product_service_count   = 1
inventory_service_count = 1
api_service_count       = 2
task_ingress = [
  { from_port = 8000, to_port = 8000, protocol = "tcp" },
  { from_port = 8001, to_port = 8001, protocol = "tcp" },
  { from_port = 8002, to_port = 8002, protocol = "tcp" }
]


# DB variables
db_username       = "admin"
db_password       = "pass1234!"
instance_class    = "db.t3.micro"
allocated_storage = 20
engine            = "postgres"
engine_version    = "15"
db_port           = 5432

# Redis variables
node_type       = "cache.t3.micro"
num_cache_nodes = 1
