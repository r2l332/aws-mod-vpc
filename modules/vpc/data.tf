data "aws_availability_zones" "available_azs" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}
