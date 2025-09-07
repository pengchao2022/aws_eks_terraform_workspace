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

  # 完全移除 cluster_addons 或者正确配置 CoreDNS
  cluster_addons = {
    coredns = {
      most_recent = true
      # 添加配置解决安装问题
      configuration_values = jsonencode({
        replicaCount = 2
        resources = {
          limits = {
            cpu    = "100m"
            memory = "170Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "70Mi"
          }
        }
      })
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      # 确保 VPC-CNI 正确配置，这对网络连通性很重要
      configuration_values = jsonencode({
        env = {
          # 启用 Pod 网络
          ENABLE_POD_ENI = "true"
        }
      })
    }
  }

  # 添加这些配置来帮助解决网络问题
  enable_irsa = true

  # 确保节点安全组有正确的出口规则
  node_security_group_additional_rules = {
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  tags = {
    Environment = local.environment
    Terraform   = "true"
  }
}