## VPC Creation
resource "aws_vpc" "eks_vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = local.vpc_tags
}

## EIP Creation For NAT GW
resource "aws_eip" "nat_gateway_ips" {
  count = length(var.pub_subnet_cidrs) > 0 ? 1 : 0
  vpc   = true
}

## Internet Gateway IPv4 and IPv6
resource "aws_internet_gateway" "this" {
  count = length(var.pub_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    local.internet_gateway,
  )
}

resource "aws_egress_only_internet_gateway" "eks_egress_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = local.egress_gateway
}

## Creation Of NAT GW's
resource "aws_nat_gateway" "eks_private_nat_gws" {
  count = length(var.pub_subnet_cidrs) > 0 ? 1 : 0

  allocation_id = element(
    aws_eip.nat_gateway_ips.*.id, count.index
  )
  subnet_id = element(
    aws_subnet.eks_subnet_public.*.id, count.index
  )

  tags = merge(
    {
      "Name" = format(
        "%s.nat.gw.%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    }
  )

  depends_on = [aws_internet_gateway.this]
}

## Route Table Creation
resource "aws_route_table" "eks_route_table_public" {
  count  = length(var.pub_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    {
      "Name" = format(
        "%s.public.rt.%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    }
  )
}

resource "aws_route_table" "eks_route_table_private" {
  count = length(var.priv_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    {
      "Name" = format(
        "%s.private.rt.%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    }
  )
}

## Route Table Creation
resource "aws_route_table_association" "public_eks_association" {
  count = length(var.pub_subnet_cidrs) > 0 ? length(var.pub_subnet_cidrs) : 0

  subnet_id      = element(aws_subnet.eks_subnet_public.*.id, count.index)
  route_table_id = aws_route_table.eks_route_table_public[0].id
}

resource "aws_route_table_association" "private_eks_association" {
  count = length(var.priv_subnet_cidrs) > 0 ? length(var.priv_subnet_cidrs) : 0

  subnet_id      = element(aws_subnet.eks_subnet_private.*.id, count.index)
  route_table_id = aws_route_table.eks_route_table_private[0].id

}

## AWS Route creation
resource "aws_route" "public_eks_route" {
  count = length(var.pub_subnet_cidrs) > 0 ? length(var.pub_subnet_cidrs) : 0

  route_table_id         = aws_route_table.eks_route_table_public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.priv_subnet_cidrs) > 0 ? 1 : 0

  route_table_id         = element(aws_route_table.eks_route_table_private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_private_nat_gws[0].id

  timeouts {
    create = "5m"
  }
}

## Subnet Creation
resource "aws_subnet" "eks_subnet_public" {
  count                = length(var.pub_subnet_cidrs) > 0 ? length(var.pub_subnet_cidrs) : 0
  vpc_id               = aws_vpc.eks_vpc.id
  cidr_block           = var.pub_subnet_cidrs[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available_azs.names, count.index))) > 0 ? element(data.aws_availability_zones.available_azs.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available_azs.names, count.index))) == 0 ? element(data.aws_availability_zones.available_azs.names, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "%s.public.snet.%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    },
    local.subnet_tags_public,
  )
}


resource "aws_subnet" "eks_subnet_private" {
  count                = length(var.priv_subnet_cidrs) > 0 ? length(var.priv_subnet_cidrs) : 0
  vpc_id               = aws_vpc.eks_vpc.id
  cidr_block           = var.priv_subnet_cidrs[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available_azs.names, count.index))) > 0 ? element(data.aws_availability_zones.available_azs.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available_azs.names, count.index))) == 0 ? element(data.aws_availability_zones.available_azs.names, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "%s.private.snet-%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    },
    local.subnet_tags_private,
  )
}
