variable "service_name" {
  type = string
  description = "サービス名"
}

variable "subnet_ids" {
  type = list(string)
  description = "EKSのコントロールプレーンを接続するサブネットのid"
}

variable "alb_security_group_id" {
  type = string
  description = "外部公開するALB に設定する security group の id, ALB から eks クラスターへのアクセスを許可するために使用"
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