locals {
  vpc_tags = {
    Name    = "eks.vpc"
    service = "k8s"
  }
  subnet_tags_public = {
    service = "k8s"
  }
  subnet_tags_private = {
    service = "k8s"
  }
  egress_gateway = {
    Name    = "eks.egress.gateway"
    service = "k8s"
  }
  internet_gateway = {
    Name    = "eks.internet.gateway"
    service = "k8s"
  }
}