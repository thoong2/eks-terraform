region              = "ap-southeast-1"
environment         = "dev"
project_name        = "my-eks"
vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnet_cidrs = ["10.0.0.0/22", "10.0.4.0/22"]
private_subnet_cidrs = [
  "10.0.8.0/22",
  "10.0.12.0/22",
  "10.0.16.0/22",
  "10.0.20.0/22",
  "10.0.24.0/22",
  "10.0.28.0/22"
]

node_groups = {
  general = {
    instance_type = "t3.medium"
    ami_id        = "AL2_x86_64"
    min_size     = 1
    max_size     = 3
    desired_size = 2
    disk_size    = 20
  }
  compute = {
    instance_type = "c5.xlarge"
    ami_id        = "AL2_x86_64"
    min_size     = 1
    max_size     = 5
    desired_size = 2
    disk_size    = 50
  }
}