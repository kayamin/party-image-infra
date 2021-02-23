# インターネット経由で EKS の Worker ノードへアクセスするためのALBを作成

# LINEサーバーからアクセスする用のエンドポイント
resource "aws_alb" "public" {
  name = "${var.service_name}-alb-public"
  load_balancer_type = "application"
  internal = false
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = false

  tags = var.cost_allocation_tags
}

# Websocketからアクセスする用のエンドポイント
resource "aws_alb" "publish" {
  name = "${var.service_name}-alb-publish"
  load_balancer_type = "application"
  internal = false
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = false

  tags = var.cost_allocation_tags
}

# ターゲットグループを作成
resource "aws_alb_target_group" "eks_node_group_public" {
  name = "${var.service_name}-public"
  vpc_id = var.vpc_id
  port = var.k8s_node_port_collector
  protocol = "HTTP"
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    path = "/"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }

  tags = var.cost_allocation_tags
}

resource "aws_alb_target_group" "eks_node_group_publish" {
  name = "${var.service_name}-publish"
  vpc_id = var.vpc_id
  port = var.k8s_node_port_publisher
  protocol = "HTTP"
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    path = "/"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }

  tags = var.cost_allocation_tags
}

# ターゲットグループと eks の node group を紐付け
resource "aws_autoscaling_attachment" "eks_node_group_public" {
  autoscaling_group_name = var.eks_node_group_auto_scaling_group_name
  alb_target_group_arn = aws_alb_target_group.eks_node_group_public.arn
}

# コンソールから追加したワイルドカード証明書を追加
resource "aws_autoscaling_attachment" "eks_node_group_publish" {
  autoscaling_group_name = var.eks_node_group_auto_scaling_group_name
  alb_target_group_arn = aws_alb_target_group.eks_node_group_publish.arn
}

# ALB を SSL終端として HTTPS通信を受け，eks の workerノードへフォワードする
resource "aws_lb_listener" "https_public" {
  load_balancer_arn = aws_alb.public.arn
  port = 443
  protocol = "HTTPS"
  # TLS 1.2以上のミニ対応
  ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn = aws_acm_certificate.wild.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.eks_node_group_public.arn
  }
}

resource "aws_lb_listener" "https_publish" {
  load_balancer_arn = aws_alb.publish.arn
  port = 443
  protocol = "HTTPS"
  # TLS 1.2以上のミニ対応
  ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn = aws_acm_certificate.wild.arn

  default_action {
    type = "forward"
    tar~get_group_arn = aws_alb_target_group.eks_node_group_publish.arn
  }
}