# EKS Cluster Role
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
      Name = "${var.cluster_name}-cluster-role"
    }
  
}

# Attach required policies to cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

# Node Group Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

locals {
  # Normalize the policies path to ensure consistent formatting
  normalized_policies_path = trimsuffix(var.policies_path, "/")
  
  # Flatten node groups policies for easier processing
  node_group_policies = flatten([
    for ng_key, ng_value in var.node_groups : [
      for policy in ng_value.node_group.policies : {
        node_group = ng_key
        policy     = policy
      }
    ]
  ])
}

# Create IAM roles for each node group
resource "aws_iam_role" "node_groups" {
  for_each = var.node_groups

  name        = "${var.cluster_name}-${each.key}-node-role"
  description = "IAM role for EKS node group ${each.key}"
  
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-${each.key}-node-role"
    }
  )
}

# Attach managed EKS worker node policy
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  for_each = var.node_groups

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_groups[each.key].name
}

# Attach managed CNI policy
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  for_each = var.node_groups

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_groups[each.key].name
}

# Attach managed EC2 Container Registry read-only policy
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  for_each = var.node_groups

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_groups[each.key].name
}

# Create custom policies from JSON files
resource "aws_iam_policy" "custom_policies" {
  for_each = toset(distinct([for item in local.node_group_policies : item.policy]))

  name        = each.key
  description = "Custom policy for EKS node groups: ${each.key}"
  policy      = file("${local.normalized_policies_path}/${each.key}.json")

  tags = var.tags
}

# Attach custom policies to roles
resource "aws_iam_role_policy_attachment" "custom_policy_attachments" {
  for_each = {
    for policy in local.node_group_policies :
    "${policy.node_group}-${policy.policy}" => policy
  }

  role       = aws_iam_role.node_groups[each.value.node_group].name
  policy_arn = aws_iam_policy.custom_policies[each.value.policy].arn
}
