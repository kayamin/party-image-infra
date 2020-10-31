resource "aws_eks_cluster" "cluster" {
  name     = "${var.service_name}-cluster"
  role_arn = aws_iam_role.eks-master.arn

  version  = "1.16"

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_public_access = true
  }
}