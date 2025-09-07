# nodegroup.tf (更新后的版本)
resource "aws_eks_node_group" "this" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "${local.name}-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn  # 使用原生资源的ARN
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type        = "AL2_x86_64"  # 使用Amazon Linux 2避免AMI问题
  instance_types  = [var.node_instance_type]
  capacity_type   = "ON_DEMAND"

  # 节点标签
  labels = {
    environment = local.environment
    node-type   = "python-worker"
  }

  remote_access {
    ec2_ssh_key = "your-ssh-key-name"  # 替换为您的SSH密钥名称
  }

  tags = {
    "Name" = "${local.name}-node"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${local.name}" = "owned"
  }

  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly
  ]
}