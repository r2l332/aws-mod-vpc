variable "name" {
  description = "Name of VPC stack - This will also be used in subnet names and other network related components"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC Cidr to create e.g `10.0.0.0/16`"
  type        = string
}
variable "pub_subnet_cidrs" {
  description = "List of public subnets to create"
  type        = list(string)
}
variable "priv_subnet_cidrs" {
  description = "List of private subnets to create"
  type        = list(string)
}
variable "region" {
  description = "Where to deploy VPC"
  type        = string
}
