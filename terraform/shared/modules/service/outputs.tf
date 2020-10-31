output "eks_node_group_auto_scaling_group_name" {
  value = aws_eks_node_group.cluster-node-group.resources[0].autoscaling_groups[0].name
}

output "kubeconfig_for_eks" {
  value = local.kubeconfig
}

locals {
  kubeconfig = <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority[0].data}
    server: ${aws_eks_cluster.cluster.endpoint}
  name: ${aws_eks_cluster.cluster.name}
users:
- name: ${aws_eks_cluster.cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - ap-northeast-1
      - eks
      - get-token
      - --cluster-name
      - ${aws_eks_cluster.cluster.name}
      command: aws
      env: null
contexts:
- context:
    cluster: ${aws_eks_cluster.cluster.name}
    user: ${aws_eks_cluster.cluster.name}
  name: ${aws_eks_cluster.cluster.name}
current-context: ${aws_eks_cluster.cluster.name}
EOF
}