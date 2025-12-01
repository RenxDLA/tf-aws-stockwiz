resource "aws_ecs_cluster" "ecs_cluster" {
  name = lower("${var.app_name}-ecs-cluster-${var.environment}")

  tags = {
    Environment = var.environment
    Name        = lower("${var.app_name}-ecs-cluster-${var.environment}")
    Creator     = "Terraform"
  }
}

resource "aws_ecs_task_definition" "ecs_product_task" {
  for_each = toset(var.environment_to_deploy)

  family                   = lower("${var.app_name}-product-task-${each.key}")
  network_mode             = var.task_network_mode
  requires_compatibilities = ["${var.service_launch_type}"]
  cpu                      = var.task_product.cpu
  memory                   = var.task_product.memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = lower("${var.app_name}-product-service-${each.key}")
      image     = lower("${var.ecr_url}:product-service-${each.key}-latest")
      essential = true

      # generated with AI
      # environment variables service to connect to DB, Redis and the other services
      environment = [
        {
          name  = "DATABASE_URL"
          value = lookup(var.database_url, each.key, "")
        },
        {
          name  = "REDIS_URL"
          value = lookup(var.redis_url, each.key, "")
        }
      ]

      portMappings = [
        {
          containerPort = var.task_product_container.container_port
          hostPort      = var.task_product_container.host_port
          protocol      = var.task_product_container.protocol
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_product_service[each.key].name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs-product-service"
        }
      }
    }
  ])


  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-product-task-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_ecs_service" "ecs_product_service" {
  for_each = toset(var.environment_to_deploy)

  name            = lower("${var.app_name}-product-service-${each.key}")
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_product_task[each.key].arn
  desired_count   = var.product_service_count
  launch_type     = var.service_launch_type

  network_configuration {
    security_groups  = var.security_group_ids
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }

  # generated with AI
  # Register with ALB target group for Product
  load_balancer {
    target_group_arn = var.product_tg_arn[each.key]
    container_name   = lower("${var.app_name}-product-service-${each.key}")
    container_port   = var.task_product_container.container_port
  }

  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-product-service-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_ecs_task_definition" "ecs_inventory_task" {
  for_each = toset(var.environment_to_deploy)

  family                   = lower("${var.app_name}-inventory-task-${each.key}")
  network_mode             = var.task_network_mode
  requires_compatibilities = ["${var.service_launch_type}"]
  cpu                      = var.task_inventory.cpu
  memory                   = var.task_inventory.memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = lower("${var.app_name}-inventory-service-${each.key}")
      image     = lower("${var.ecr_url}:inventory-service-${each.key}-latest")
      essential = true

      environment = [
        {
          name  = "DATABASE_URL"
          value = lookup(var.database_url, each.key, "")
        },
        {
          name  = "REDIS_URL"
          value = lookup(var.redis_addr, each.key, "")
        }
      ]

      portMappings = [
        {
          containerPort = var.task_inventory_container.container_port
          hostPort      = var.task_inventory_container.host_port
          protocol      = var.task_inventory_container.protocol
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_inventory_service[each.key].name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs-inventory-service"
        }
      }
    }
  ])


  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-inventory-task-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_ecs_service" "ecs_inventory_service" {
  for_each = toset(var.environment_to_deploy)

  name            = lower("${var.app_name}-inventory-service-${each.key}")
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_inventory_task[each.key].arn
  desired_count   = var.inventory_service_count
  launch_type     = var.service_launch_type

  network_configuration {
    security_groups  = var.security_group_ids
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }
  # generated with AI
  # Register with ALB target group for Inventory
  load_balancer {
    target_group_arn = var.inventory_tg_arn[each.key]
    container_name   = lower("${var.app_name}-inventory-service-${each.key}")
    container_port   = var.task_inventory_container.container_port
  }

  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-inventory-service-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_ecs_task_definition" "ecs_api_task" {
  for_each = toset(var.environment_to_deploy)

  family                   = lower("${var.app_name}-api-task-${each.key}")
  network_mode             = var.task_network_mode
  requires_compatibilities = ["${var.service_launch_type}"]
  cpu                      = var.task_api.cpu
  memory                   = var.task_api.memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = lower("${var.app_name}-api-service-${each.key}")
      image     = lower("${var.ecr_url}:api-service-${each.key}-latest")
      essential = true

      environment = [
        {
          name  = "DATABASE_URL"
          value = lookup(var.database_url, each.key, "")
        },
        {
          name  = "REDIS_URL"
          value = lookup(var.redis_addr, each.key, "")
        },
        {
          name  = "PRODUCT_SERVICE_URL"
          value = "http://${var.alb_dns_name[each.key]}${var.target_group_path_prefix_product}"
        },
        {
          name  = "INVENTORY_SERVICE_URL"
          value = "http://${var.alb_dns_name[each.key]}${var.target_group_path_prefix_inventory}"
        }
      ]

      portMappings = [
        {
          containerPort = var.task_api_container.container_port
          hostPort      = var.task_api_container.host_port
          protocol      = var.task_api_container.protocol
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_api_service[each.key].name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs-api-service"
        }
      }
    }
  ])


  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-api-service-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_ecs_service" "ecs_api_service" {
  for_each = toset(var.environment_to_deploy)

  name            = lower("${var.app_name}-api-service-${each.key}")
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_api_task[each.key].arn
  desired_count   = var.api_service_count
  launch_type     = var.service_launch_type

  network_configuration {
    security_groups  = var.security_group_ids
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_groups_arn[each.key]
    container_name   = lower("${var.app_name}-api-service-${each.key}")
    container_port   = var.task_api_container.container_port
  }

  tags = {
    Environment = each.key
    Name        = lower("${var.app_name}-api-service-${each.key}")
    Creator     = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "ecs_product_service" {
  for_each = toset(var.environment_to_deploy)

  name              = lower("/ecs/services/${each.key}/${var.app_name}-product-service")
  retention_in_days = 7

  tags = {
    Environment = each.key
    Name        = lower("/ecs/services/${each.key}/${var.app_name}-product-service")
    Creator     = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "ecs_inventory_service" {
  for_each = toset(var.environment_to_deploy)

  name              = lower("/ecs/services/${each.key}/${var.app_name}-inventory-service")
  retention_in_days = 7

  tags = {
    Environment = each.key
    Name        = lower("/ecs/services/${each.key}/${var.app_name}-inventory-service")
    Creator     = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "ecs_api_service" {
  for_each = toset(var.environment_to_deploy)

  name              = lower("/ecs/services/${each.key}/${var.app_name}-api-service")
  retention_in_days = 7

  tags = {
    Environment = each.key
    Name        = lower("/ecs/services/${each.key}/${var.app_name}-api-service")
    Creator     = "Terraform"
  }
}
