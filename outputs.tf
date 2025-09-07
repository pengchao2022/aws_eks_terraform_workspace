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

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate authority data for cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "kubeconfig" {
  description = "kubectl config file contents"
  value       = module.eks.kubeconfig_raw  # 修正为 kubeconfig_raw
  sensitive   = true
}

output "node_group_ids" {
  description = "Node group IDs"
  value       = [for ng in module.eks.eks_managed_node_groups : ng.node_group_id]
}

output "node_group_arns" {
  description = "Node group ARNs"
  value       = [for ng in module.eks.eks_managed_node_groups : ng.node_group_arn]
}

# 新增一些有用的输出
output "cluster_version" {
  description = "Kubernetes cluster version"
  value       = module.eks.cluster_version
}

output "cluster_status" {
  description = "Cluster status"
  value       = module.eks.cluster_status
}

output "cluster_platform_version" {
  description = "Cluster platform version"
  value       = module.eks.cluster_platform_version
}