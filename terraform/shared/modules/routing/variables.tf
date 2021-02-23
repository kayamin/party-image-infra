variable "service_name" {
  type = string
  description = "サービス名"
}

variable "domain_name" {
  type = string
  description = "ドメイン名"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "k8s_node_port_collector" {
  type = number
  description = "EKS の kubernetes cluster で作成する NodePort Service で利用するポート番号. ALBから eks クラスターへのアクセスをこのポートへフォワードする"
}

variable "k8s_node_port_publisher" {
  type = number
  description = "EKS の kubernetes cluster で作成する NodePort Service で利用するポート番号. ALBから eks クラスターへのアクセスをこのポートへフォワードする"
}

variable "eks_node_group_auto_scaling_group_name" {
  type = string
  description = "albを紐付ける，eks node group の autoscaling group の名称"
}

variable "cost_allocation_tags" {
  type = map
  description = "コスト配分タグ"
}