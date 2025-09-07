# main.tf
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  name        = var.cluster_name  # 直接使用集群名称，不重复添加环境
  environment = var.environment
  # 使用 Amazon Linux 2 AMI
  ami_id = data.aws_ami.amazon_linux_2.id
  }

