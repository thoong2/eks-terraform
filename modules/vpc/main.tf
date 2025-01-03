terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.cluster_name}-vpc"
    Environment = var.environment
    Terraform = "true"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.cluster_name}-igw"
    Environment = var.environment
    Terraform = "true"
  }
}

locals {
  # Flatten public subnets for easier iteration
  public_subnet_config = flatten([
    for subnet_key, subnet in var.public_subnets : [
      for index, cidr in subnet.cidrs : {
        name         = subnet.name
        cidr         = cidr
        az_index     = index
        subnet_key   = subnet_key
      }
    ]
  ])

  # Flatten private subnets for easier iteration
  private_subnet_config = flatten([
    for subnet_key, subnet in var.private_subnets : [
      for index, cidr in subnet.cidrs : {
        name         = subnet.name
        cidr         = cidr
        az_index     = index
        subnet_key   = subnet_key
      }
    ]
  ])
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = {
    for index, config in local.public_subnet_config :
    "${config.subnet_key}-${config.az_index}" => config
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = var.azs[each.value.az_index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.cluster_name}-${each.value.name}-${each.value.az_index + 1}"
    Environment                                 = var.environment
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.environment}"  = "shared"
    SubnetType                                  = each.value.name
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = {
    for index, config in local.private_subnet_config :
    "${config.subnet_key}-${config.az_index}" => config
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = var.azs[each.value.az_index]

  tags = {
    Name                                        = "${var.cluster_name}-${each.value.name}-${each.value.az_index + 1}"
    Environment                                 = var.environment
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.environment}"  = "shared"
    SubnetType                                  = each.value.name
  }
}


# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.cluster_name}-nat-eip"
    Environment = var.environment
    Terraform   = "true"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.cluster_name}-nat"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.cluster_name}-public-rt"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Private Route Table with NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "${var.cluster_name}-private-rt"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
