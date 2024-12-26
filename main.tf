module "vpc" {
  source = "./modules/vpc"

  environment    = var.environment
  vpc_cidr      = var.vpc_cidr
  azs           = var.availability_zones
  public_cidrs  = var.public_subnet_cidrs
  private_cidrs = var.private_subnet_cidrs
}

module "eks_iam" {
  source = "./modules/iam"

  cluster_name = "my-eks-cluster"
  
  # Custom policies for cluster if needed
  custom_cluster_policies = [
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }
  ]

  # Custom policies for different node groups
  node_group_policies = {
    app = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::app-bucket",
          "arn:aws:s3:::app-bucket/*"
        ]
      }
    ]
    monitoring = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      }
    ]
  }

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "${var.project_name}-${var.environment}"
  environment     = var.environment
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = concat(module.vpc.private_subnet_ids)
  node_groups    = var.node_groups
}