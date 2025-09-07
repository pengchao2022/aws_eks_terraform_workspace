# nodegroup.tf (更新后的版本)
resource "aws_eks_node_group" "this" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "eks-py-cluster-dev-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type        = "AL2_x86_64"
  instance_types  = [var.node_instance_type]
  capacity_type   = "ON_DEMAND"

  # 移除 remote_access 配置（如果没有SSH密钥）
  # remote_access {
  #   ec2_ssh_key = "your-ssh-key-name"
  # }

  # 节点标签
  labels = {
    environment = local.environment
    node-type   = "python-worker"
  }

  tags = {
    "Name" = "${local.name}-node"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${module.eks.cluster_name}" = "owned"
  }

  # 添加 lifecycle 配置防止自动重命名
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,  # 忽略自动缩放的变化
      tags["eks:nodegroup-name"]       # 忽略自动生成的标签
    ]
  }

  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly
  ]
}