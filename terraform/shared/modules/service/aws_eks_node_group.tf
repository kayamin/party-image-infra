resource "aws_eks_node_group" "cluster-node-group" {
  cluster_name = aws_eks_cluster.cluster.name
  node_group_name = "${var.service_name}-cluster-node-group"
  node_role_arn = aws_iam_role.eks-cluster-node-role.arn
  subnet_ids = var.subnet_ids

  instance_types = ["m5.large"]
  disk_size = 20

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-node-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-cluster-node-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-cluster-node-role-AmazonEC2ContainerRegistryReadOnly
  ]

  tags = var.cost_allocation_tags
}
