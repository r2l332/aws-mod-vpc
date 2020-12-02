module "test_vpc" {
  source            = "./../"
  name              = var.name
  vpc_cidr          = var.vpc_cidr
  region            = var.region
}
