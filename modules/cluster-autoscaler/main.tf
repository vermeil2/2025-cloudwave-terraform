resource "aws_eks_addon" "pod_identity" {
  cluster_name  = var.eks_cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.5-eksbuild.2"
}

resource "helm_release" "cluster_autoscaler" {
  name = "autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.45.0"

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_cluster_name
  }

   
  set {
    name  = "awsRegion"
    value = "ap-northeast-1"
  }

  
}