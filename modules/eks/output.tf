output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer_url" {
  value = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
