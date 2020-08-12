terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = "vpc/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.ddb_name
  }
}