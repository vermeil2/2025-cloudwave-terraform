# ###################################################
# # Network Outputs
# ###################################################

# output "private_subnet_id_zone1" {
#   description = "ID of the private subnet in Zone 1"
#   value       = module.network.private_subnet_id_zone1
# }

# output "private_subnet_id_zone2" {
#   description = "ID of the private subnet in Zone 2"
#   value       = module.network.private_subnet_id_zone2
# }

# output "public_subnet_id_zone1" {
#   description = "ID of the public subnet in Zone 1"
#   value       = module.network.public_subnet_id_zone1
# }

# output "public_subnet_id_zone2" {
#   description = "ID of the public subnet in Zone 2"
#   value       = module.network.public_subnet_id_zone2
# }



# ###################################################
# # EKS Cluster Outputs
# ###################################################
# output "eks_cluster_name" {
#   description = "Name of the EKS Cluster"
#   value       = aws_eks_cluster.eks.name
# }

# output "eks_cluster_id" {
#   description = "ID of the EKS Cluster"
#   value       = aws_eks_cluster.eks.id
# }

# output "eks_cluster_arn" {
#   description = "ARN of the EKS Cluster"
#   value       = aws_eks_cluster.eks.arn
# }

# output "eks_cluster_version" {
#   description = "Kubernetes version of the EKS Cluster"
#   value       = aws_eks_cluster.eks.version
# }

# output "eks_cluster_endpoint" {
#   description = "Endpoint of the EKS Cluster"
#   value       = aws_eks_cluster.eks.endpoint
# }

# output "eks_cluster_certificate_authority" {
#   description = "Certificate authority of the EKS Cluster"
#   value       = aws_eks_cluster.eks.certificate_authority[0].data
# }

# output "eks_cluster_identity_oidc" {
#   description = "OIDC Identity provider of the EKS Cluster"
#   value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
# }

# ###################################################
# # IAM Role Outputs (EKS Cluster)
# ###################################################
# output "eks_iam_role_arn" {
#   description = "IAM Role ARN for the EKS Cluster"
#   value       = aws_iam_role.eks.arn
# }

# output "eks_iam_role_name" {
#   description = "IAM Role Name for the EKS Cluster"
#   value       = aws_iam_role.eks.name
# }

# ###################################################
# # IAM Role Outputs (EKS Worker Nodes)
# ###################################################
# output "eks_nodes_iam_role_arn" {
#   description = "IAM Role ARN for EKS Nodes"
#   value       = aws_iam_role.nodes.arn
# }

# output "eks_nodes_iam_role_name" {
#   description = "IAM Role Name for EKS Nodes"
#   value       = aws_iam_role.nodes.name
# }

# ###################################################
# # IAM Policy Outputs (EKS Worker Nodes)
# ###################################################
# output "eks_worker_node_policy_arn" {
#   description = "IAM Policy ARN for EKS Worker Nodes"
#   value       = aws_iam_role_policy_attachment.amazon_eks_worker_node_policy.policy_arn
# }

# output "eks_cni_policy_arn" {
#   description = "IAM Policy ARN for EKS CNI"
#   value       = aws_iam_role_policy_attachment.amazon_eks_cni_policy.policy_arn
# }

# output "eks_ec2_container_registry_policy_arn" {
#   description = "IAM Policy ARN for EC2 Container Registry Read Only"
#   value       = aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only.policy_arn
# }

# ###################################################
# # EKS Node Group Outputs
# ###################################################
# output "eks_node_group_name" {
#   description = "Name of the EKS Node Group"
#   value       = aws_eks_node_group.general.node_group_name
# }

# output "eks_node_group_arn" {
#   description = "ARN of the EKS Node Group"
#   value       = aws_eks_node_group.general.arn
# }

# output "eks_node_group_status" {
#   description = "Status of the EKS Node Group"
#   value       = aws_eks_node_group.general.status
# }

# output "eks_node_group_instance_types" {
#   description = "Instance types of the EKS Node Group"
#   value       = aws_eks_node_group.general.instance_types
# }

# output "aws_eks_node_group_general" {
#   value = aws_eks_node_group.general  
# }

# output "eks_node_group_capacity_type" {
#   description = "Capacity type of the EKS Node Group"
#   value       = aws_eks_node_group.general.capacity_type
# }

# output "eks_node_group_subnet_ids" {
#   description = "Subnet IDs for the EKS Node Group"
#   value       = aws_eks_node_group.general.subnet_ids
# }

# output "oidc_provider_url" {
#   description = "The OIDC provider URL for the EKS cluster"
#   value       = data.aws_iam_openid_connect_provider.eks.url
# }

# output "oidc_provider_arn" {
#   description = "The ARN of the OIDC provider for the EKS cluster"
#   value       = data.aws_iam_openid_connect_provider.eks.arn
# }