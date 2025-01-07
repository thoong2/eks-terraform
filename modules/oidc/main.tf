locals {
  # Flatten policies for each service account
  service_account_policies = flatten([
    for sa_key, sa in var.service_accounts : [
      for policy_key, policy in sa.iam_role.policies : {
        sa_key       = sa_key
        policy_key   = policy_key
        sa_name      = sa.name
        namespace    = sa.namespace
        role_name    = sa.iam_role.name
        actions      = policy.actions
        resources    = policy.resources
      }
    ]
  ])
}


data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-oidc-provider"
    }
  )
}

data "aws_iam_policy_document" "assume_role_policy" {
  for_each = var.service_accounts

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${each.value.namespace}:${each.value.name}"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "service_account" {
  for_each           = var.service_accounts
  name               = "${each.value.iam_role.name}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.key].json

  tags = merge(
    var.tags,
    {
      ServiceAccount = each.value.name
      Namespace     = each.value.namespace
    }
  )
}

resource "aws_iam_role_policy" "service_account" {
  for_each = {
    for policy in local.service_account_policies :
    "${policy.sa_key}.${policy.policy_key}" => policy
  }

  name = "${each.value.role_name}-${each.value.policy_key}-${var.environment}"
  role = aws_iam_role.service_account[each.value.sa_key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = each.value.actions
        Resource = each.value.resources
      }
    ]
  })
}
