variable "service_name" {
  type = string
  description = "サービス名"
}

variable "domain_name" {
  type = string
  description = "ドメイン名"
}

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

variable "k8s_node_port_collector" {
  type = number
  description = "EKS の kubernetes cluster で作成する NodePort Service で利用するポート番号. ALBから eks クラスターへのアクセスをこのポートへフォワードする"
}

variable "k8s_node_port_publisher" {
  type = number
  description = "EKS の kubernetes cluster で作成する NodePort Service で利用するポート番号. ALBから eks クラスターへのアクセスをこのポートへフォワードする"
}

variable "cost_allocation_tags" {
  type = map
  description = "コスト配分タグ"
}