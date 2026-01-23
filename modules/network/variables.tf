# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }

variable "private_zone1_cidr" {
  description = "CIDR block for private subnet in zone 1"
  type        = string
}

variable "private_zone2_cidr" {
  description = "CIDR block for private subnet in zone 2"
  type        = string
}

variable "public_zone1_cidr" {
  description = "CIDR block for public subnet in zone 1"
  type        = string
}

variable "public_zone2_cidr" {
  description = "CIDR block for public subnet in zone 2"
  type        = string
}

variable "zone1" {
  description = "Availability zone 1"
  type        = string
}

variable "zone2" {
  description = "Availability zone 2"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "eks_name" {
  description = "EKS Cluster name"
  type        = string
}

# variable "igw_id" {
#   description = "Internet Gateway ID"
#   type        = string
# }