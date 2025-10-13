module "vpc" {
  source   = "./modules/vpc"
  name     = var.name
  vpc_cidr = var.vpc_cidr
}

module "iam" {
  count  = var.create_iam ? 1 : 0
  source = "./modules/iam"

  name           = var.name
  aws_account_id = var.aws_account_id
  user_arn       = var.user_arn
}

module "eks-cluster" {
  count  = var.create_eks ? 1 : 0
  source = "./modules/eks"

  name            = var.name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  role_arn        = module.iam[0].role_arn
}
