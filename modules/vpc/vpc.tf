resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true

  tags = local.vpc_tags
}

resource "aws_internet_gateway" "eks_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = local.internet_gateway
}

resource "aws_egress_only_internet_gateway" "eks_egress_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = local.egress_gateway
}

resource "aws_route_table" "eks_route_table" {
  for_each = toset(local.cidrs)
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = each.value
    gateway_id = aws_internet_gateway.eks_gateway.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eks_egress_gateway.id
  }
}

data "aws_route" "eks_route" {
  for_each               = toset(local.cidrs)
  route_table_id         = aws_route_table.eks_route_table[each.value].id
  destination_cidr_block = each.value
}

resource "aws_subnet" "eks_subnet_public" {
  for_each   = toset(local.cidrs)
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = each.value
  availability_zone = 
  tags       = local.subnet_tags_public
}

resource "aws_subnet" "eks_subnet_private" {
  for_each   = toset(local.cidrs)
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = each.value
  availability_zone = 
  tags       = local.subnet_tags_private
}