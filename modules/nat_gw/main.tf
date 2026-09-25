resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat_eip"
  }
}
# Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = var.public_subnet_id

  tags = {
    Name = "${var.env}-nat_gateway"
  }
}
# Create Private route table
resource "aws_route_table" "private-rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-Private-RT"
  }
}
# Create Private route
resource "aws_route" "private_nat_route" {
  route_table_id = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}
# Associate Route Table with Private Subnets
resource "aws_route_table_association" "private_rta" {
  for_each = toset(var.private_subnet_ids)
  subnet_id = each.value
  route_table_id = aws_route_table.private-rt.id
}
