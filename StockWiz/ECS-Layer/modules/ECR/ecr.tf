resource "aws_ecr_repository" "ecr_repo" {

  name                 = lower("${var.app_name}-ecr-repo")
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name    = lower("${var.app_name}-ecr-repo")
    Creator = "Terraform"
  }
}
