module "network" {
  source             = "./modules/network"
  
  private_zone1_cidr = var.private_zone1_cidr
  private_zone2_cidr = var.private_zone2_cidr
  public_zone1_cidr  = var.public_zone1_cidr
  public_zone2_cidr  = var.public_zone2_cidr

  zone1              = var.zone1
  zone2              = var.zone2
  env                = var.env
  eks_name           = var.eks_name
}

module "eks" {
  source             = "./modules/eks"

  region             = var.region
  env                = var.env

  subnet_ids         = [ module.network.private_subnet_id_zone1, module.network.private_subnet_id_zone2 ]

  eks_name           = var.eks_name
  eks_version        = var.eks_version
  
  instance_types     = [ var.instance_types ]
  eks_cluster_name = var.eks_name
}

module "metrics_server" {
  source = "./modules/metric-server"  
}

module "cluster_autoscaler" {
  source = "./modules/cluster-autoscaler"

  eks_cluster_name = var.eks_name
  env = var.env
}

module "lb-controller" {
  source              = "./modules/lb-controller"
  cluster_name        = var.eks_name
  vpc_id              = module.network.vpc_id
  service_account_name = "aws-load-balancer-controller" 
  chart_version       = "1.12.0" 
}


module "monitoring" {
  source = "./modules/monitoring"
  # grafana oidc
  oidc_provider_url = data.aws_iam_openid_connect_provider.eks.url
  oidc_provider_arn = data.aws_iam_openid_connect_provider.eks.arn
  
  eks_cluster_name = aws_eks_cluster.eks.name
  eks_node_group_arn = aws_eks_node_group.general.arn
}

module "argocd" {
  source = "./modules/argocd"
 
}

module "ecr_irsa" {
  source = "./modules/ecr-irsa"
  
  oidc_issuer_url = module.eks.oidc_issuer_url
  
  service_account_name = "ecr-reader-sa"
  ecr_access_namespaces = ["frontend", "backend"]

  oidc_provider_url = module.eks.oidc_provider_arn
  env = var.env
  
}



