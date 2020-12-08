variable "name" {}
variable "vpc_cidr" {}
variable "pub_subnet_cidrs" {
}
variable "priv_subnet_cidrs" {
}
variable "data_subnet_cidrs" {
}
variable "public_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
variable "data_cidrs" {
  type    = list(string)
  default = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
}
variable "region" {}
