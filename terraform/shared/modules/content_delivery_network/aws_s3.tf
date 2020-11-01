resource "aws_s3_bucket" "image_store" {
  bucket = "party-image-store"
  acl    = "private"

  tags = var.cost_allocation_tags
}