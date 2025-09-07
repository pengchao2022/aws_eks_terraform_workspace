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
  environment = terraform.workspace
  name        = "${var.cluster_name}-${local.environment}"
  node_names  = ["eks-python-node-1", "eks-python-node-2"]
  
  # 使用 Amazon Linux 2 AMI
  ami_id = data.aws_ami.amazon_linux_2.id
}