locals {
  vpc_tags = {
    Name    = "${var.name}.vpc"
    service = "web"
  }
  subnet_tags_public = {
    service = "web"
  }
  subnet_tags_private = {
    service = "web"
  }
  egress_gateway = {
    Name    = "${var.name}.egress.gateway"
    service = "web"
  }
  internet_gateway = {
    Name    = "${var.name}.internet.gateway"
    service = "web"
  }
}
