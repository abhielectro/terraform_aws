variable "env" {}
variable "public_subnet_id" {
  description = "Public subnet ID where NAT Gateway will be created"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID where the NAT Gateway and route table are used"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}
