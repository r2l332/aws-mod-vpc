locals {
  vpc_tags {
    name    = "eks.vpc"
    service = "k8s"
  }
  subnet_tags_public {
    name    = "eks.public"
    service = "k8s"
  }
  subnet_tags_private {
    name    = "eks.private"
    service = "k8s"
  }
  cidrs = var.subnet_cidrs
}