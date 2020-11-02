resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "${var.service_name}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "eventId"
  range_key = "postTimestamp"


  local_secondary_index {
    name = "photoTimestamp"
    projection_type = "ALL"
    range_key = "photoTimestamp"
  }

  local_secondary_index {
    name = "happinessScore"
    projection_type = "ALL"
    range_key = "happinessScore"
  }

  attribute {
    name = "eventId"
    type = "S"
  }

  attribute {
    name = "postTimestamp"
    type = "S"
  }

  attribute {
    name = "photoTimestamp"
    type = "S"
  }

  attribute {
    name = "happinessScore"
    type = "N"
  }

//  Terraform では キー，インデックスとして用いる attribute だけ定義する. その他は後でレコードごとに自由で追加可能
//  attribute {
//    name = "s3Bucket"
//    type = "S"
//  }
//
//  attribute {
//    name = "s3ObjectKey"
//    type = "S"
//  }
//
//  attribute {
//    name = "userId"
//    type = "S"
//  }
//
//  attribute {
//    name = "detectFacesResult"
//    type = "S"
//  }
//
//  attribute {
//    name = "detectLabelsResult"
//    type = "S"
//  }
//
//  attribute {
//    name = "detectModerationLabelsResult"
//    type = "S"
//  }

  tags = var.cost_allocation_tags
}