resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat_eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = var.public_subnet_id

  tags = {
    Name = "${var.env}-nat_gateway"
  }
}

