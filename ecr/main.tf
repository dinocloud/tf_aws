resource "aws_ecr_repository" "registry" {
  name                 = var.registry_name
  image_tag_mutability = "MUTABLE"
  count                = var.create
  image_scanning_configuration {
    scan_on_push = true
  }
}