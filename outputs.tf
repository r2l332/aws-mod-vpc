output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Returns VPC id"
}

output "public_subnet" {
  value       = module.vpc.public_subnet
  description = "Returns public subnet ids"
}

output "private_subnet" {
  value       = module.vpc.private_subnet
  description = "Returns private subnet ids"
}

output "route_table_ids" {
  value       = module.vpc.route_table_ids
  description = "Returns route table ids"
}
