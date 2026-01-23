data "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "kube-prom-stack-grafana"
    namespace = "monitoring"
  }
  depends_on = [ helm_release.kube_prometheus_stack ]
}

data "aws_route53_zone" "highfive-oliveyoung" {
  name = "highfive-oliveyoung.com"
}

resource "aws_route53_record" "grafana_dns" {
  zone_id = data.aws_route53_zone.highfive-oliveyoung.id
  name    = "grafana"
  type    = "CNAME"
  ttl     = 300

  records = [data.kubernetes_ingress_v1.grafana.status[0].load_balancer[0].ingress[0].hostname]

  depends_on = [data.kubernetes_ingress_v1.grafana]
}

