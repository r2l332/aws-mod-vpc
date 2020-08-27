output "vpc_id" {
  value       = module.vpc.eks_vpc_id
  description = "Returns VPC id"
}

output "public_subnet" {
  value       = module.eks_vpc.eks_public_subnet
  description = "Returns public subnet ids"
}

output "private_subnet" {
  value       = module.vpc.eks_private_subnet
  description = "Returns private subnet ids"
}

output "route_table_id" {
  value       = module.vpc.route_table_id
  description = "Returns route table id"
}
