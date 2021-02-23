# EKS cluster のセキュリティグループに alb からの通信を許可するルールを追加する
resource "aws_security_group_rule" "all_alb_collector" {
  security_group_id        = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  type                     = "ingress"
  from_port                = var.k8s_node_port_collector
  to_port                  = var.k8s_node_port_collector
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}

resource "aws_security_group_rule" "all_alb_publisher" {
  security_group_id        = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  type                     = "ingress"
  from_port                = var.k8s_node_port_publisher
  to_port                  = var.k8s_node_port_publisher
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}