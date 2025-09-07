# eks.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.name
  cluster_version = var.cluster_version
  iam_role_arn    = aws_iam_role.eks_cluster.arn

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {} # 使用外部的 aws_eks_node_group 资源

  cluster_addons = {
    coredns = null # 关键修改：显式设置为 null 以禁用 CoreDNS 安装
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  tags = {
    Environment = local.environment
    Terraform   = "true"
  }
}