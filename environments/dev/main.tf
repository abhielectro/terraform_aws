data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-main_vpc"]
  }
}
data "aws_subnet" "public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-Public_Subnet_1"]
  }
  #  id = "subnet-006b0d661b83bda50"
  vpc_id = data.aws_vpc.main_vpc.id
}
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
}
data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.all.ids)

  id = each.value
}
locals {
  private_subnet_ids = [
    for id, subnet in data.aws_subnet.all :
    id
    if startswith(
      lookup(subnet.tags, "Name", ""),
      "${var.env}-Private_Subnet_"
    )
  ]
  public_subnet_ids = [
    for id, subnet in data.aws_subnet.all :
    id
    if startswith(
      lookup(subnet.tags, "Name", ""),
      "${var.env}-Public_Subnet_"
    )
  ]
}

module "nat_gateway" {
  source = "../../modules/nat_gw"

  env              = var.env
  vpc_id           = data.aws_vpc.main_vpc.id
  public_subnet_id = data.aws_subnet.public_subnet_1.id
  # Pass the private subnet IDs to the module
  private_subnet_ids = local.private_subnet_ids
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  public_subnet_ids  = local.public_subnet_ids
  private_subnet_ids = local.private_subnet_ids
  project_name       = var.project_name
  env                = var.env

  node_group_name = var.node_group_name
  instance_types  = var.instance_types

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  enable_fargate       = true
  fargate_profile_name = var.farget_profile_name
  fargate_namespace    = var.farget_namespace
}

locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

