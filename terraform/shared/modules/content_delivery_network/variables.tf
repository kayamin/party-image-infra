variable "service_name" {
  type = string
  description = "サービス名"
}

variable "cost_allocation_tags" {
  type = map
  description = "コスト配分タグ"
}