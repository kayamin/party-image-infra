resource "aws_s3_bucket" "tfstate" {
  bucket = "party-image-tfstate"
  acl = "private"
  versioning {
    enabled = true
  }
}

terraform {
  backend "s3" {
    bucket = "party-image-tfstate"
    region = "ap-northeast-1"
    key = "terraform.tfstate"
  }
}