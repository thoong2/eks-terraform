# Security Groups Module

This module creates security groups in AWS based on the input map of security groups.

## Input Variables

- `security_groups`: A map of security groups where each key is the security group name and each value is an object containing:
  - `description`: A description of the security group.
  - `ingress`: An object containing ingress rules:
    - `from_port`: The starting port of the range (e.g., 80).
    - `to_port`: The ending port of the range (e.g., 80).
    - `protocol`: The protocol (e.g., `tcp`).
    - `cidr_blocks`: List of CIDR blocks to allow inbound traffic.
  - `egress`: Similar to `ingress` but for outbound rules.
  - `tags`: A map of tags to apply to the security group.

- `vpc_id`: The VPC ID where the security groups will be created.

## Example Usage

### 1. Configuration in `terraform.tfvars`

In the `terraform.tfvars` file, you will configure the parameters for the security groups as follows:

```hcl
vpc_id = "vpc-xxxxxxxx"

security_groups = {
  "web-sg" = {
    description = "Security group for web servers"
    ingress = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "web-sg"
    }
  },
  "db-sg" = {
    description = "Security group for database servers"
    ingress = {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "db-sg"
    }
  }
}
```

### 2. Using the module in the main.tf file in the root folder
In the main.tf file in the root folder, you will use the security_groups module with the configuration declared in terraform.tfvars:


```hclhcl
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id          = var.vpc_id
  security_groups = var.security_groups
}
```

### 3. Output from the module
After applying the configuration, the module will create the Security Groups corresponding to the configuration declared in terraform.tfvars. Here is an example of the output value of the module:

```hcl
security_group_ids = {
  "web-sg" = "sg-0abc1234def567890"
  "db-sg"  = "sg-09876xyz1234abcd0"
}
```