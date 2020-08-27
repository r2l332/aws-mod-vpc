resource "aws_eks_cluster" "eks_cluster" {
  name  = locals.cluster_name

  vpc_config {
    subnet_ids = [var.subnet_ids]
  }
}
