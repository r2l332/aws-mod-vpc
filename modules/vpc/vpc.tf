## VPC Creation
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = local.vpc_tags
}

## EIP Creation For NAT GW
resource "aws_eip" "nat_gateway_ips" {
  count = length(local.pubsnet) > 0 ? 1 : 0
  vpc   = true
}

## Internet Gateway IPv4 and IPv6
resource "aws_internet_gateway" "this" {
  count = length(local.pubsnet) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    local.internet_gateway,
  )
}

## Creation Of NAT GW's
resource "aws_nat_gateway" "private_nat_gws" {
  count = length(local.pubsnet) > 0 ? 1 : 0

  allocation_id = element(
    aws_eip.nat_gateway_ips.*.id, count.index
  )
  subnet_id = element(
    aws_subnet.subnet_public.*.id, count.index
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
resource "aws_route_table" "route_table_public" {
  count  = length(local.pubsnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

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

resource "aws_route_table" "route_table_private" {
  count = length(local.privsnet) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

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

resource "aws_route_table" "route_table_data" {
  count = length(local.datasnet) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format(
        "%s.data.rt.%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    }
  )
}

## Route Table Creation
resource "aws_route_table_association" "public_association" {
  count = length(local.pubsnet) > 0 ? length(local.pubsnet) : 0

  subnet_id      = element(aws_subnet.subnet_public.*.id, count.index)
  route_table_id = aws_route_table.route_table_public[0].id
}

resource "aws_route_table_association" "private_association" {
  count = length(local.privsnet) > 0 ? length(local.privsnet) : 0

  subnet_id      = element(aws_subnet.subnet_private.*.id, count.index)
  route_table_id = aws_route_table.route_table_private[0].id

}

resource "aws_route_table_association" "data_association" {
  count = length(local.datasnet) > 0 ? length(local.datasnet) : 0

  subnet_id      = element(aws_subnet.subnet_data.*.id, count.index)
  route_table_id = aws_route_table.route_table_data[0].id

}

## AWS Route creation
resource "aws_route" "public_route" {
  count = length(local.pubsnet) > 0 ? length(local.pubsnet) : 0

  route_table_id         = aws_route_table.route_table_public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = length(local.privsnet) > 0 ? 1 : 0

  route_table_id         = element(aws_route_table.route_table_private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private_nat_gws[0].id

  timeouts {
    create = "5m"
  }
}


## Subnet Creation
resource "aws_subnet" "subnet_public" {
  count                = length(local.pubsnet) > 0 ? length(local.pubsnet) : 0
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = local.pubsnet[count.index]
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


resource "aws_subnet" "subnet_private" {
  count                = length(local.privsnet) > 0 ? length(local.privsnet) : 0
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = local.privsnet[count.index]
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

resource "aws_subnet" "subnet_data" {
  count                = length(local.datasnet) > 0 ? length(local.datasnet) : 0
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = local.datasnet[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available_azs.names, count.index))) > 0 ? element(data.aws_availability_zones.available_azs.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available_azs.names, count.index))) == 0 ? element(data.aws_availability_zones.available_azs.names, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "%s.data.snet-%s",
        var.name,
        element(data.aws_availability_zones.available_azs.names, count.index),
      )
    },
    local.subnet_tags_private,
  )
}