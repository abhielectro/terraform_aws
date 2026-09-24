output "vpc_id" {
  value       = module.my-vpc.vpc_id
  description = "The ID of the VPC"
}
output "vpc_cidr" {
  value       = module.my-vpc.vpc_cidr
  description = "The CIDR block of the VPC"
}
