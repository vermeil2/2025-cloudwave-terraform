data "aws_iam_policy_document" "grafana_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:monitoring:grafana-sa"]
    }
  }
}

resource "aws_iam_policy" "grafana_cloudwatch" {
  name = "grafana-cloudwatch-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:DescribeAlarms",
          "ec2:DescribeRegions",
          "ec2:DescribeInstances",
          "logs:StartQuery",
          "logs:GetQueryResults",
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
          "autoscaling:DescribeAutoScalingGroups",
          "elasticloadbalancing:DescribeLoadBalancers"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "grafana_irsa_role" {
  name               = "eks-grafana-irsa"
  assume_role_policy = data.aws_iam_policy_document.grafana_assume_role.json
}

resource "aws_iam_role_policy_attachment" "grafana_attach" {
  role       = aws_iam_role.grafana_irsa_role.name
  policy_arn = aws_iam_policy.grafana_cloudwatch.arn
}

#####################################
# service account
#####################################
resource "kubernetes_service_account" "grafana_sa" {
  metadata {
    name      = "grafana-sa"
    namespace = "monitoring"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.grafana_irsa_role.arn
    }
  }
  depends_on = [ kubernetes_namespace.monitoring ]
}

resource "kubernetes_service_account" "ebs_csi_controller_sa" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_driver_role.arn
    }
  }
}

#################################################
# ebs_csi_driver 설정
#################################################
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name    = var.eks_cluster_name
  addon_name      = "aws-ebs-csi-driver"
  addon_version   = "v1.42.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn
}

data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name        = "AmazonEBSCSIDriverPolicy"
  description = "Policy for EBS CSI driver"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeVolumes",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:CreateTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "AmazonEKS_EBS_CSI_DriverRole"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
}

resource "aws_eks_pod_identity_association" "ebs_csi_driver_association" {
  cluster_name    = var.eks_cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi_driver_role.arn
}
