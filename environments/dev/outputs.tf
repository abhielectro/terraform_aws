output "vpc_id" {
  value       = data.aws_vpc.main_vpc.id
  description = "The ID of the VPC"
}
output "vpc_cidr" {
  value       = data.aws_vpc.main_vpc.cidr_block
  description = "The CIDR block of the VPC"
}

output "nat_gateway_eip" {
  description = "The public IP address of the NAT Gateway"
  value       = module.nat_gateway.nat_eip
}