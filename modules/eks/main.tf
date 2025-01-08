resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  
  vpc_config {
    subnet_ids = concat(
      flatten([for subnet_ids in values(var.private_subnet_ids_by_type) : subnet_ids]),
      flatten([for subnet_ids in values(var.public_subnet_ids_by_type) : subnet_ids])
    )
  }
}

resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = var.node_group_role_arns[each.key]
  subnet_ids      = var.private_subnet_ids_by_type[each.value.subnet_type]

  instance_types = each.value.node_group.instance_types
  ami_type       = each.value.node_group.ami_type
  capacity_type  = each.value.node_group.capacity_type
  disk_size      = each.value.node_group.disk_size

  scaling_config {
    desired_size = each.value.node_group.scaling_config.desired_size
    max_size     = each.value.node_group.scaling_config.max_size
    min_size     = each.value.node_group.scaling_config.min_size
  }

  dynamic "taint" {
    for_each = each.value.node_group.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  labels = merge(
    each.value.node_group.labels,
    {
      "eks.amazonaws.com/nodegroup" = each.key
    }
  )

  tags = merge(
    each.value.node_group.tags,
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      NodeGroup   = each.key
    }
  )

  depends_on = [aws_eks_cluster.main]
}
