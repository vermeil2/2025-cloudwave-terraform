variable "env" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "zone1" {
  description = "First availability zone"
  type        = string
}

variable "zone2" {
  description = "Second availability zone"
  type        = string
}

variable "eks_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version for EKS"
  type        = string
}

variable "private_zone1_cidr" {
  description = "CIDR block for private subnet in zone1"
  type        = string
}

variable "private_zone2_cidr" {
  description = "CIDR block for private subnet in zone2"
  type        = string
}

variable "public_zone1_cidr" {
  description = "CIDR block for public subnet in zone1"
  type        = string
}

variable "public_zone2_cidr" {
  description = "CIDR block for public subnet in zone2"
  type        = string
}

variable "instance_types" {
  description = "node instance types"
  type = string
}