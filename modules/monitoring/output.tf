# IAM Policy Outputs
output "grafana_cloudwatch_policy_arn" {
  description = "The ARN of the CloudWatch policy for Grafana"
  value       = aws_iam_policy.grafana_cloudwatch.arn
}

# IAM Role Outputs
output "grafana_irsa_role_arn" {
  description = "The ARN of the IAM role for Grafana IRSA"
  value       = aws_iam_role.grafana_irsa_role.arn
}

output "grafana_irsa_role_name" {
  description = "The name of the IAM role for Grafana IRSA"
  value       = aws_iam_role.grafana_irsa_role.name
}

# Grafana Service Account and Namespace
output "grafana_service_account_name" {
  description = "The name of the service account for Grafana"
  value       = "grafana-sa"
}

output "grafana_namespace" {
  description = "The namespace where Grafana is deployed"
  value       = "monitoring"
}

