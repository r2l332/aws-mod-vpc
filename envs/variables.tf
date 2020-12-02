variable "name" {}
variable "vpc_cidr" {}
variable "region" {}
variable "pub_subnet_cidrs" {
  description = "List of public subnets to create"
  type        = list(string)
}
variable "priv_subnet_cidrs" {
  description = "List of private subnets to create"
  type        = list(string)
}
