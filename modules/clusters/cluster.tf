resource "aws_eks_cluster" "eks_cluster" {
  count = var.create_vpc == true ? 1 : 0
  name  = locals.cluster_name

  vpc_config {
    subnet_ids = [module.vpc.subnet_ids]
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  count    = var.create_vpc != true ? 0 : 1
  for_each = data.aws_subnet_ids.eks_subnet.ids
  name     = locals.cluster_name

  vpc_config {
    subnet_ids = [each.value]
  }
}
