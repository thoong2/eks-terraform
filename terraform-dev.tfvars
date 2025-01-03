project_name        = "my-eks"
environment         = "dev"
region              = "ap-southeast-1"

# VPC
vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnet_cidrs = {
  app = {
    name  = "app"
    cidrs =["10.0.0.0/22", "10.0.4.0/22"]
  }
  load-balancer = {
    name  = "load-balancer"
    cidrs =["10.0.8.0/22", "10.0.12.0/22"]
  }
}
private_subnet_cidrs = {
  backend = {
    name  = "backend"
    cidrs =["10.0.16.0/22", "10.0.20.0/22"]
  }
  model-serving = {
    name  = "model-serving"
    cidrs =["10.0.24.0/22", "10.0.28.0/22"]
  }
  logging-tracing = {
    name  = "logging-tracing"
    cidrs =["10.0.32.0/22", "10.0.36.0/22"]
  }
  metrics-monitoring = {
    name  = "metrics-monitoring"
    cidrs =["10.0.40.0/22", "10.0.44.0/22"]
  }
}

# Node group
node_groups = {
  app = {
    subnet_type = "app"
    node_group = {
      instance_type   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 3
        desired_size = 2
      }
      labels = {
        "node.kubernetes.io/purpose" = "app"
      }
      taints = []
      tags = {}
      policies = {}
    }
  }
  backend = {
    subnet_type = "backend"
    node_group = {
      instance_type   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 3
        desired_size = 2
      }
      labels = {
        "node.kubernetes.io/purpose" = "backend"
      }
      taints = []
      tags = {}
      policies = {
      "s3-read-only" = [{
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::my-bucket",
          "arn:aws:s3:::my-bucket/*"
        ]
        }]
      }
    }
  }
  model-serving = {
    subnet_type = "model-serving"
    node_group = {
      instance_type   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 3
        desired_size = 2
      }
      labels = {
        "node.kubernetes.io/purpose" = "model-serving"
      }
      taints = [
        {
          key    = "workload"
          value  = "data"
          effect = "NoSchedule"
        }
      ]
      tags = {
        Environment = "dev"
      }
      policies = {
      "s3-read-only" = [{
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::my-bucket",
          "arn:aws:s3:::my-bucket/*"
        ]
        }]
      }
    }
  }
  logging-tracing = {
    subnet_type = "logging-tracing"
    node_group = {
      instance_type   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 3
        desired_size = 2
      }
      labels = {
        "node.kubernetes.io/purpose" = "logging-tracing"
      }
      taints = []
      tags = {}
      policies = {}
    }
  }
  metrics-monitoring = {
    subnet_type = "metrics-monitoring"
    node_group = {
      instance_type   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 3
        desired_size = 2
      }
      labels = {
        "node.kubernetes.io/purpose" = "metrics-monitoring"
      }
      taints = []
      tags = {}
      policies = {}
    }
  }
}