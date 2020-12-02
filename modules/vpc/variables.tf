variable "name" {}
variable "vpc_cidr" {}
variable "pub_subnet_cidrs" {
  type = list
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "priv_subnet_cidrs" {
  type = list
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"] 
}
variable "region" {}
