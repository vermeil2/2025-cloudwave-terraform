variable "eks_name" {
  description = "EKS 클러스터의 이름"
  type        = string
}

variable "eks_version" {
  description = "EKS 클러스터의 버전"
  type        = string
}

variable "env" {
  description = "배포 환경 (예: dev, staging, prod)"
  type        = string
}

variable "instance_types" {
  description = "EKS 노드 그룹의 인스턴스 타입"
  type        = list(string)
}



variable "subnet_ids" {
  description = "EKS 클러스터가 사용할 서브넷 ID 목록"
  type        = list(string)
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "eks_cluster_name" {
  type = string  
}