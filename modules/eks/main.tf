locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = concat(
      var.public_subnet_ids,
      var.private_subnet_ids
    )
  }
  
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
  tags = local.common_tags
}

# Managed Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.node_group_name

  node_role_arn = aws_iam_role.node_role.arn

  subnet_ids = var.private_subnet_ids

  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
}
# CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.node_group
  ]
}

# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_cluster.eks
  ]
}

# Kube Proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_cluster.eks
  ]
}

# Fargate Profile
resource "aws_eks_fargate_profile" "farprofile" {
  count = var.enable_fargate ? 1 : 0
  cluster_name           = aws_eks_cluster.eks.name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = aws_iam_role.fargate_role.arn

  subnet_ids = var.private_subnet_ids

  selector {
    namespace = var.fargate_namespace
  }
}
