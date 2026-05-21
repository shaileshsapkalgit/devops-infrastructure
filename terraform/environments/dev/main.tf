# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  single_nat_gateway = true
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"

  project_name          = var.project_name
  environment           = var.environment
  image_retention_count = 5
}

# IAM BASE - EKS se PEHLE (no dependency on EKS)
module "iam_base" {
  source = "../../modules/iam-base"

  project_name = var.project_name
  environment  = var.environment
}

# EKS - IAM base ke BAAD
module "eks" {
  source = "../../modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  cluster_version    = var.cluster_version
  cluster_role_arn   = module.iam_base.eks_cluster_role_arn
  node_role_arn      = module.iam_base.eks_nodes_role_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id

  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  use_spot_instances = false

  depends_on = [module.iam_base, module.vpc]
}

# IAM IRSA - EKS ke BAAD (needs OIDC provider)
module "iam_irsa" {
  source = "../../modules/iam-irsa"

  project_name      = var.project_name
  environment       = var.environment
  aws_account_id    = var.aws_account_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  depends_on = [module.eks]
}