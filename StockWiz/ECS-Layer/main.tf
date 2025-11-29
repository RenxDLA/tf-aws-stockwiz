module "security_groups" {
  source = "./modules/Security-Group"

  environment_to_deploy = var.environment_to_deploy
  app_name              = var.app_name
  vpc_id                = data.aws_vpc.network_vpc.id
  ingress               = var.ingress
  egress                = var.egress
}

module "load_balancer" {
  source = "./modules/Load-Balancer"

  environment_to_deploy = var.environment_to_deploy
  app_name              = var.app_name
  lb_type               = var.lb_type
  lb_security_group_ids = module.security_groups.alb_sg_ids
  public_subnet_ids     = data.aws_subnets.public.ids
  lb_tg_port            = var.lb_tg_port
  lb_tg_protocol        = var.lb_tg_protocol
  vpc_id                = data.aws_vpc.network_vpc.id
  lb_tg_type            = var.lb_tg_type

  lb_health_check = var.lb_health_check

  lb_listener_port        = var.lb_listener_port
  lb_listener_protocol    = var.lb_listener_protocol
  lb_listener_action_type = var.lb_listener_action_type

}