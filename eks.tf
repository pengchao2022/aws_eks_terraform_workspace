# eks.tf (简化版)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.name
  cluster_version = var.cluster_version
  iam_role_arn    = aws_iam_role.eks_cluster.arn

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # 不定义任何节点组，模块就不会创建节点组
  # 这样我们可以在外部使用 aws_eks_node_group 资源

  cluster_addons = {
    coredns = {
      most_recent = true
    }
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