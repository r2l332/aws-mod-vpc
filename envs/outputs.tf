output "vpc_id" {
  value = module.test_vpc.vpc_id
}

output "public_subnet" {
  value = module.test_vpc.public_subnet
}

output "private_subnet" {
  value = module.test_vpc.private_subnet
}

output "route_table_ids" {
  value = module.test_vpc.route_table_ids
}
