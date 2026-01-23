data "aws_iam_openid_connect_provider" "oidc" {
  url = var.oidc_issuer_url
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = [
        for ns in var.ecr_access_namespaces :
        "system:serviceaccount:${ns}:${var.service_account_name}"
      ]
    }
  }
}

resource "aws_iam_role" "ecr_irsa_role" {
  name               = "${var.env}-ecr-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecr_read_access" {
  role       = aws_iam_role.ecr_irsa_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "kubernetes_namespace" "ecr_access" {
  for_each = toset(var.ecr_access_namespaces)

  metadata {
    name = each.key
  }
}

resource "kubernetes_service_account" "ecr_reader_sa" {
  for_each = toset(var.ecr_access_namespaces)

  metadata {
    name      = var.service_account_name
    namespace = each.key
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ecr_irsa_role.arn
    }
  }
}