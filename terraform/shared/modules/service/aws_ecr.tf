resource "aws_ecr_repository" "main" {
  name = var.service_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.cost_allocation_tags
}