resource "aws_vpc" "eks_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "eks.vpc"
  }
}

resource "aws_subnet" "eks_subnet_public" {
  for_each   = toset(local.cidrs)
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = each.value
  tags       = local.subnet_tags_public
}

resource "aws_subnet" "eks_subnet_private" {
  for_each   = toset(local.cidrs)
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = each.value
  tags       = local.subnet_tags_private
}