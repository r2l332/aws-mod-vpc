provider "aws" {
  region                      = var.region
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    ec2      = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    s3       = "http://localhost:4566"
    sts      = "http://localhost:4566"
  }
}

module "test_vpc" {
  source            = "./../"
  name              = var.name
  vpc_cidr          = var.vpc_cidr
  region            = var.region
  pub_subnet_cidrs  = var.pub_subnet_cidrs
  priv_subnet_cidrs = var.priv_subnet_cidrs
  data_subnet_cidrs = var.data_subnet_cidrs
}
