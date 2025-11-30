module "security_groups" {
  source = "./modules/Security-Group"

  environment_to_deploy = var.environment_to_deploy
  app_name              = var.app_name
  vpc_id                = data.aws_vpc.network_vpc.id
  ingress               = var.ingress
  task_ingress          = var.task_ingress
  egress                = var.egress
}

module "load_balancer" {
  source = "./modules/Load-Balancer"

  environment_to_deploy = var.environment_to_deploy
  app_name              = var.app_name
  lb_type               = var.lb_type
  lb_security_group_ids = module.security_groups.alb_sg_ids
  public_subnet_ids     = data.aws_subnets.public.ids
  # lb uses the same port that the api container is using
  lb_tg_port            = var.task_api_container.container_port
  lb_tg_protocol        = var.lb_tg_protocol
  vpc_id                = data.aws_vpc.network_vpc.id
  lb_tg_type            = var.lb_tg_type

  lb_health_check = var.lb_health_check

  lb_listener_port        = var.lb_listener_port
  lb_listener_protocol    = var.lb_listener_protocol
  lb_listener_action_type = var.lb_listener_action_type

}

module "ecs_cluster" {
  source = "./modules/ECS"

  environment              = var.environment
  environment_to_deploy    = var.environment_to_deploy
  app_name                 = var.app_name
  public_subnet_ids        = data.aws_subnets.public.ids
  security_group_ids       = module.security_groups.ecs_tasks_sg_ids
  alb_target_groups_arn    = module.load_balancer.alb_target_groups_arn
  service_launch_type      = var.service_launch_type
  task_network_mode        = var.task_network_mode
  task_execution_role_arn  = data.aws_iam_role.lab_role.arn
  task_product             = var.task_product
  task_product_container   = var.task_product_container
  task_inventory           = var.task_inventory
  task_inventory_container = var.task_inventory_container
  task_api                 = var.task_api
  task_api_container       = var.task_api_container
  product_service_count    = var.product_service_count
  inventory_service_count  = var.inventory_service_count
  api_service_count        = var.api_service_count
  ecr_url                  = data.aws_ecr_repository.ecr_url.repository_url

}
