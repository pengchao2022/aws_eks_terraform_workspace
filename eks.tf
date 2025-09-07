# eks.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.name
  cluster_version = var.cluster_version

  # 正确的参数名称是 iam_role_arn，不是 cluster_role_arn
  iam_role_arn = aws_iam_role.eks_cluster.arn

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"  # 使用 Amazon Linux 2
    instance_types = [var.node_instance_type]
    disk_size      = 20
  }

  eks_managed_node_groups = {
    python-nodes = {
      name           = "${local.name}-node-group"
      instance_types = [var.node_instance_type]
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size

      # 使用正确的 IAM 角色
      iam_role_arn = aws_iam_role.eks_node.arn

      # 节点标签
      labels = {
        environment = local.environment
        node-type   = "python-worker"
      }

      # 为每个节点设置名称
      tags = {
        Name = "${local.name}-node"
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/${local.name}" = "owned"
      }
    }
  }

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