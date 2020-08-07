module "eks_vpc" {
  source       = "./modules/vpc"
  create_vpc   = var.create_vpc
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "eks_cluster" {
  source     = "./modules/clusters"
  name       = var.name
  create_vpc = var.create_vpc
}

module "eks_workers" {
  source = "./modules/workers"
}