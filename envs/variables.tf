variable "name" {}
variable "vpc_cidr" {}
variable "region" {}
variable "pub_subnet_cidrs" {
  description = "List of public subnets to create"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "priv_subnet_cidrs" {
  description = "List of private subnets to create"
  type        = list(string)
  default.    = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
