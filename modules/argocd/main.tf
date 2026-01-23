resource "helm_release" "argocd" {  
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  name       = "argocd"
  namespace  = "argocd"
  
  create_namespace = true

  values = [
    file("${path.module}/argocd-values.yaml")
  ]
}