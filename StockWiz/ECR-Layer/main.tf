module "ecr" {
  source = "./modules/ECR"

  app_name                  = var.app_name
  vpc_id                    = data.aws_vpc.network_vpc.id
  image_tag_mutability      = var.image_tag_mutability
}

module "lambda" {
  source = "./modules/Lambda"
  lambda_name    = var.lambda_name
  lambda_handler = var.lambda_handler
  runtime = var.runtime
  
}