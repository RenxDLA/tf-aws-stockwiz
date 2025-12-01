resource "aws_ecs_cluster" "ecs_cluster" {
  name = lower("${var.app_name}-ecs-cluster-${var.environment}")

  tags = {
    Environment = var.environment
    Name        = lower("${var.app_name}-ecs-cluster-${var.environment}")
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
      name      = lower("${var.app_name}-product-service-${each.key}")
      image     = lower("${var.ecr_url}:product-service-${each.key}-latest")
      essential = false

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
    },
    {
      name      = lower("${var.app_name}-inventory-service-${each.key}")
      image     = lower("${var.ecr_url}:inventory-service-${each.key}-latest")
      essential = false

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
    },
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
          value = "http://localhost:8001"
        },
        {
          name  = "INVENTORY_SERVICE_URL"
          value = "http://localhost:8002"
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

      dependsOn = [
        {
          containerName = lower("${var.app_name}-product-service-${each.key}")
          condition     = "START"
        },
        {
          containerName = lower("${var.app_name}-inventory-service-${each.key}")
          condition     = "START"
        }
      ]
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
