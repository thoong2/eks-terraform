# Terraform Module: Security Groups

## Description

This Terraform module is used to create **Security Groups** on AWS. It supports configuring multiple Security Groups with flexible **Ingress** and **Egress** rules.

## Input Variables

- **vpc_id** (string): The ID of the VPC where the Security Groups will be created.
- **security_groups** (map): A map of Security Groups, each containing Ingress and Egress rules.

## Output

- **security_group_ids** (map): A map of Security Group names and their corresponding IDs.

## Example Configuration

### main.tf

```hcl
module "security_groups" {
  source          = "./modules/security-group"
  vpc_id          = var.vpc_id
  security_groups = var.security_groups
}

output "security_group_ids" {
  value = module.security_groups.security_group_ids
}
```

### terraform.tfvars

```hcl
vpc_id = "vpc-0a1b2c3d"

security_groups = {
  "web-sg" = {
    description = "Security Group for Web Servers"
    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },

  "db-sg" = {
    description = "Security Group for Database Servers"
    ingress = [
      {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/8"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
```

### output
```hcl
security_group_ids = {
  "web-sg" = "sg-abc1234567890"
  "db-sg"  = "sg-def9876543210"
}
