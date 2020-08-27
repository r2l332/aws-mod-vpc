module "vpc" {
  source            = "./../"
  name              = var.name
  create_network    = var.create_network
  vpc_cidr          = var.vpc_cidr
  pub_subnet_cidrs  = var.pub_subnet_cidrs
  priv_subnet_cidrs = var.priv_subnet_cidrs
  region            = var.region
}