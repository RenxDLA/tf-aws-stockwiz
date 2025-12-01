module "vpc" {
  source              = "./modules/VPC"
  vpc_cidr            = var.vpc_cidr
  app_name            = var.app_name
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "internet_gateway" {
  source      = "./modules/Internet-Gateway"
  vpc_id      = module.vpc.vpc_id
  app_name    = var.app_name
}

module "route_table" {
  source                 = "./modules/Route-Table"
  vpc_id                 = module.vpc.vpc_id
  internet_gateway_id    = module.internet_gateway.internet_gateway_id
  route_table_cidr_block = var.route_table_cidr_block
  public_subnet_ids      = module.vpc.public_subnet_ids
  app_name               = var.app_name
}
