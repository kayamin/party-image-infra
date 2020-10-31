variable "vpc_cider_block" {
  type = string
}

variable "subnet_num" {
  type = number
  description = "public, private サブネットを作成する数"
}

variable "eks_tags_for_node_group" {
  type = map
  description = "eks node group に割り当てるサブネットの tag に付ける必要がある値"
}

variable "cost_allocation_tags" {
  type = map
  description = "コスト配分タグ"
}