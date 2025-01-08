module "vpc" {
  source = "./modules/vpc"

  cluster_name    = "${var.project_name}-${var.environment}"
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}

module "namespace" {
  source = "./modules/namespace"

  environment = var.environment
  services    = var.namespaces
}

module "eks_iam" {
  source = "./modules/eks-iam"

  cluster_name = "${var.project_name}-${var.environment}"
  node_groups  = var.node_groups
  policies_path = var.policies_path
}

module "eks" {
  source = "./modules/eks"

  cluster_name = "${var.project_name}-${var.environment}"
  environment = var.environment

  vpc_id = module.vpc.vpc_id
  private_subnet_ids_by_type = module.vpc.private_subnet_ids_by_type
  public_subnet_ids_by_type = module.vpc.public_subnet_ids_by_type

  node_groups = var.node_groups
  cluster_role_arn = module.eks_iam.cluster_role_arn
  node_group_role_arns = module.eks_iam.node_group_role_arns
}

module "oidc" {
  source = "./modules/oidc"

  cluster_name     = "${var.project_name}-${var.environment}"
  environment      = var.environment
  service_accounts = var.service_accounts
}
