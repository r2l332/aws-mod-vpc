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
  egress_gateway {
    name    = "eks.egress.gateway"
    service = "k8s"
  }
  internet_gateway {
    name    = "eks.internet.gateway"
    service = "k8s"
  }
  cidrs = var.subnet_cidrs
  azs   = data.aws_availability_zones.available_azs.names
}