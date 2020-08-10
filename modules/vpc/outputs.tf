output "eks_vpc_id" {
    value = aws_vpc.eks_vpc.id
}

output "eks_public_subnet" {
    value = aws_subnet.eks_subnet_public[*].id
}

output "eks_private_subnet" {
    value = aws_subnet.eks_subnet_private[*].id
}