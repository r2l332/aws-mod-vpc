terraform {
  backend "s3" {
    bucket         = "eks-module-terraform-tfstate"
    key            = "vpc/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
  }
}