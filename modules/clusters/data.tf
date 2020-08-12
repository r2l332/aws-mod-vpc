data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["eks.vpc"]
  }
}

data "aws_subnet" "eks_subnet" {
  vpc_id   = data.aws_vpc.eks_vpc
  for_each = data.aws_subnet_ids.eks_subnets.ids
  id       = each.value
}
