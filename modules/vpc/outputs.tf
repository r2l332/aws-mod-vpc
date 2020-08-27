output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = aws_subnet.subnet_public[*].id
}

output "private_subnet" {
  value = aws_subnet.subnet_private[*].id
}

output "route_table_ids" {
  value = aws_route_table.route_table_public[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.private_nat_gws[*].id
}
