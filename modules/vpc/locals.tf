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
  privsnet = length(var.priv_subnet_cidrs) != 0 ? var.priv_subnet_cidrs : var.private_cidrs
  pubsnet  = length(var.priv_subnet_cidrs) != 0 ? var.pub_subnet_cidrs  : var.public_cidrs
}
