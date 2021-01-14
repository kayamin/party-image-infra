resource "aws_sqs_queue" "terraform_queue" {
  name                      = "${var.service_name}-sqs"
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = var.cost_allocation_tags
}