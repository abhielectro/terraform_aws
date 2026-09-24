output "vpc_id" {
    value = data.aws_vpc.main_vpc.id
    description = "The ID of the VPC"
}
output "vpc_cidr" {
  value = data.aws_vpc.main_vpc.cidr_block
  description = "The CIDR block of the VPC"
}
