locals {
    name = var.env
    
    #cidrsubnet(prefix, newbits, netnum) 
    public_subnet = [
        cidrsubnet(var.vpc_cidr, 8, 0),
        cidrsubnet(var.vpc_cidr, 8, 1),
        cidrsubnet(var.vpc_cidr, 8, 2)
    ]

    private_subnet = [
        cidrsubnet(var.vpc_cidr, 8, 3),
        cidrsubnet(var.vpc_cidr, 8, 4),
        cidrsubnet(var.vpc_cidr, 8, 5)
    ]
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-main_vpc"
  }
}

