resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = each.value.ingress.from_port
    to_port     = each.value.ingress.to_port
    protocol    = each.value.ingress.protocol
    cidr_blocks = each.value.ingress.cidr_blocks
  }

  egress {
    from_port   = each.value.egress.from_port
    to_port     = each.value.egress.to_port
    protocol    = each.value.egress.protocol
    cidr_blocks = each.value.egress.cidr_blocks
  }

  tags = each.value.tags
}

