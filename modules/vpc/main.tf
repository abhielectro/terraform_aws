locals {
  name = var.env

  #cidrsubnet(prefix, newbits, netnum) 
  public_subnets = [
    # cidrsubnet(var.vpc_cidr, 8, 0),
    # cidrsubnet(var.vpc_cidr, 8, 1),
    # cidrsubnet(var.vpc_cidr, 8, 2)
    for i in range(length(var.azs)) :
    cidrsubnet(var.vpc_cidr, 8, i)
  ]

  private_subnets = [
    for i in range(length(var.azs)) :
    cidrsubnet(var.vpc_cidr, 8, i + length(var.azs))
  ]
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-main_vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = local.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-Public_Subnet_${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${local.name}-Private_Subnet_${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.name}-my-igw"
  }
}

# Create Public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.name}-Public-RT"
  }
}

# Create Internet Route (Public Route - Internet Gateway)
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-igw.id
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_rta" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}
