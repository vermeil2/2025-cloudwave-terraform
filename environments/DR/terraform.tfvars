env         = "cj-olv-DR"
region      = "ap-northeast-1"
zone1       = "ap-northeast-1a"
zone2       = "ap-northeast-1c"
eks_name    = "cj-olv-DR-eks-cluster"
eks_version = "1.31"

instance_types = "t3.large"

private_zone1_cidr = "10.1.16.0/20"
private_zone2_cidr = "10.1.32.0/20"
public_zone1_cidr  = "10.1.144.0/20"
public_zone2_cidr  = "10.1.160.0/20"
