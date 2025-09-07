# nodegroup.tf
resource "aws_eks_node_group" "main" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "eks-py-cluster-${local.environment}-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # 使用 Amazon Linux 2
  ami_type = "AL2_x86_64"

  instance_types = [var.node_instance_type]

  # 节点标签
  labels = {
    environment = local.environment
    node-type   = "python-worker"
    os-family   = "amazon-linux"
  }

  # 资源标签
  tags = {
    Name        = "eks-py-cluster-${local.environment}-node-group"
    Environment = local.environment
    Terraform   = "true"
    OS          = "Amazon-Linux-2"
  }

  # 依赖项
  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly,
  ]

  # 生命周期配置
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}