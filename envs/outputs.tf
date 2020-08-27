output "eks_vpc_id" {
  value = module.vpc.eks_vpc_id
}

output "eks_public_subnet" {
  value = module.vpc.eks_public_subnet
}

output "eks_private_subnet" {
  value = module.vpc.eks_private_subnet
}

output "route_table_ids" {
  value = module.vpc.route_table_ids
}