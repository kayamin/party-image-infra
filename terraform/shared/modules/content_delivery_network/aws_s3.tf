resource "aws_s3_bucket" "image_store" {
  bucket = "${var.service_name}-store"
  acl    = "private"

  tags = var.cost_allocation_tags
}