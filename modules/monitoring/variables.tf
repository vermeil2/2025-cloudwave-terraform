# AWS IAM OpenID Connect Provider
variable "oidc_provider_url" {
  description = "OIDC Issuer URL for EKS Cluster"
  type        = string
}

variable "oidc_provider_arn" {
  type = string
}


# AWS VPC and Cluster Dependencies
variable "eks_cluster_name" {
  description = "The name of the EKS Cluster"
  type        = string
}

variable "eks_node_group_arn" {
  type = string  
}