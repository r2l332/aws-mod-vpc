output "eks_vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "eks_public_subnet" {
  value = aws_subnet.eks_subnet_public[*].id
}

output "eks_private_subnet" {
  value = aws_subnet.eks_subnet_private[*].id
}

output "route_table_ids" {
  value = aws_route_table.eks_route_table_public[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.eks_private_nat_gws[*].id
}
