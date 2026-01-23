###################################################
# IAM Role for EKS Cluster
###################################################
resource "aws_iam_role" "eks" {
  name = "${var.eks_name}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

###################################################
# EKS Cluster
###################################################
resource "aws_eks_cluster" "eks" {
  name     = "${var.eks_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = var.subnet_ids
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

###################################################
# IAM Role for EKS Nodes
###################################################
resource "aws_iam_role" "nodes" {
  name = "${var.env}-${var.eks_name}-eks-nodes-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

##############################################################
# Node Group
##############################################################
resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = var.eks_version
  node_group_name = "${var.eks_name}-general"
  node_role_arn   = aws_iam_role.nodes.arn

  
  subnet_ids = var.subnet_ids

  capacity_type  = "ON_DEMAND"
  #instance_types = ["t3.large"]
  instance_types = var.instance_types

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  tags = {
    Name = "${var.eks_name}-node"
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
} 

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}


resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer

  depends_on = [ aws_eks_cluster.eks ]
}

data "tls_certificate" "oidc_thumbprint" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

data "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer

  depends_on = [ aws_iam_openid_connect_provider.eks ]
}

