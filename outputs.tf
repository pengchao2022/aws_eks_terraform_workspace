# outputs.tf
output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Security group ids attached to the worker nodes"
  value       = module.eks.node_security_group_id
}

output "cluster_name" {
  description = "Kubernetes Cluster name"
  value       = module.eks.cluster_name
}

output "node_group_arn" {
  description = "Node group ARN"
  value       = module.eks.eks_managed_node_groups["python-nodes"].iam_role_arn
}

# 获取 kubeconfig 的正确方式
output "kubeconfig" {
  description = "kubectl config file contents"
  value       = module.eks.kubeconfig
  sensitive   = true
}