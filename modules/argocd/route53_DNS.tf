# data "kubernetes_ingress_v1" "argocd" {
#   metadata {
#     name      = "argocd-server"
#     namespace = "argocd"
#   }
#   depends_on = [ helm_release.argocd ]
# }

# data "aws_route53_zone" "highfive-oliveyoung" {
#   name = "highfive-oliveyoung.com"
# }

# resource "aws_route53_record" "argocd_dns" {
#   zone_id = data.aws_route53_zone.highfive-oliveyoung.id
#   name    = "dr-argocd"
#   type    = "CNAME"
#   ttl     = 300

#   records = [data.kubernetes_ingress_v1.argocd.status[0].load_balancer[0].ingress[0].hostname]

#   depends_on = [data.kubernetes_ingress_v1.argocd]
# }

