# locals {
#   env         = "cj-olv-prod"
#   region      = "ap-northeast-2"
#   zone1       = "ap-northeast-2b"
#   zone2       = "ap-northeast-2c"
#   eks_name    = "cj-olv-eks"
#   eks_version = "1.31"

#   vpc_id = "vpc-0498dc620659d1880"
#   igw_id = "igw-0d2c7b674d75dc128"
# }

env         = "cj-olv-stg"
region      = "ap-northeast-2"
zone1       = "ap-northeast-2b"
zone2       = "ap-northeast-2c"
eks_name    = "cj-olv-stg-eks-cluster"
eks_version = "1.31"

instance_types = "t3.large"


private_zone1_cidr = "10.2.16.0/20"
private_zone2_cidr = "10.2.32.0/20"
public_zone1_cidr  = "10.2.144.0/20"
public_zone2_cidr  = "10.2.160.0/20"
