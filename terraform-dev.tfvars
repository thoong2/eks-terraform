# EKS
project_name        = "thong-eks"
environment         = "dev"
region              = "ap-southeast-1"


# Namespaces
namespaces = ["app", "backend", "model-serving", "logging-tracing", "metrics-monitoring"]


# VPC
vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets = {
  public = {
    name  = "public"
    cidrs =["10.0.0.0/22", "10.0.4.0/22"]
  }
}
private_subnets = {
  app = {
    name  = "app"
    cidrs =["10.0.8.0/22", "10.0.12.0/22"]
  }
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


# Policies
policies_path = "./modules/policies"


# Node groups
node_groups = {
  app = {
    subnet_type = "app"
    node_group = {
      instance_types   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
      }
      labels = {
        "node.kubernetes.io/purpose" = "app"
      }
      taints = []
      tags = {}
      policies = []
    }
  }
  backend = {
    subnet_type = "backend"
    node_group = {
      instance_types   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
      }
      labels = {
        "node.kubernetes.io/purpose" = "backend"
      }
      taints = []
      tags = {}
      policies = ["s3-read-only"]
    }
  }
  model-serving = {
    subnet_type = "model-serving"
    node_group = {
      instance_types   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
      }
      labels = {
        "node.kubernetes.io/purpose" = "model-serving"
      }
      taints = [
        {
          key    = "workload"
          value  = "data"
          effect = "NO_SCHEDULE"
        }
      ]
      tags = {}
      policies = ["s3-read-only"]      
    }
  }
  logging-tracing = {
    subnet_type = "logging-tracing"
    node_group = {
      instance_types   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
      }
      labels = {
        "node.kubernetes.io/purpose" = "logging-tracing"
      }
      taints = []
      tags = {}
      policies = []
    }
  }
  metrics-monitoring = {
    subnet_type = "metrics-monitoring"
    node_group = {
      instance_types   = ["t3.medium"]
      ami_type        = "AL2_x86_64"
      capacity_type   = "ON_DEMAND"
      disk_size       = 20
      scaling_config = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
      }
      labels = {
        "node.kubernetes.io/purpose" = "metrics-monitoring"
      }
      taints = []
      tags = {}
      policies = []
    }
  }
}


# Service Accounts
service_accounts   = {
  model-serving-s3 = {
      namespace = "model-serving"
      name      = "model-serving-s3-sa"
      iam_role = {
        name = "model-serving-s3-sa-role"
        policies = {
          s3_access = {
            actions = ["s3:GetObject"]
            resources = ["arn:aws:s3:::my-bucket/*"]
          }
        }
      }
    }
}
