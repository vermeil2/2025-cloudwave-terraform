variable "cluster_name" {
  description = "EKS 클러스터의 이름"
  type        = string
}

variable "vpc_id" {
  description = "AWS VPC의 ID"
  type        = string
}

variable "service_account_name" {
  description = "Helm 릴리스에서 사용할 서비스 계정 이름"
  type        = string
  default     = "aws-load-balancer-controller" 
}

variable "chart_version" {
  description = "Helm 차트의 버전"
  type        = string
  default     = "1.12.0" 
}