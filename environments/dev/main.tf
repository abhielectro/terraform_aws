data "aws_vpc" "main_vpc" {
    filter {
      name = "tag:Name"
      values = ["${var.env}-main_vpc"]
    }
}
data "aws_subnet" "public_subnet_1" {
  filter {
    name = "tag:Name"
    values = [ "${var.env}-Public_Subnet_1" ]
  }
#  id = "subnet-006b0d661b83bda50"
  vpc_id = data.aws_vpc.main_vpc.id
}

module "nat_gateway" {
  source = "../../modules/nat_gw"

  env              = var.env
  public_subnet_id = data.aws_subnet.public_subnet_1.id
}
