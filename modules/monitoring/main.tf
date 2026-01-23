resource "kubernetes_namespace" "monitoring" {
  provider = kubernetes  
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  
  name       = "kube-prom-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "71.1.0"

  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_service_account.grafana_sa
  ]
}