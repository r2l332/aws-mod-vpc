module "vpc" {
  source            = "./modules/vpc"
  name              = var.name
  vpc_cidr          = var.vpc_cidr
  region            = var.region
  pub_subnet_cidrs  = var.pub_subnet_cidrs
  priv_subnet_cidrs = var.priv_subnet_cidrs
}
