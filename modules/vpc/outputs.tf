output "vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "The ID of the VPC"
}
output "vpc_cidr" {
  value       = aws_vpc.my_vpc.cidr_block
  description = "The CIDR block of the VPC"
}

# output "public_subnets" {
#     value = var.env
#     description = "The ID of the private subnets"
# }

# output "private_subnets" {
#   value = var.env
#   description = "The ID of th private subnets"
# }