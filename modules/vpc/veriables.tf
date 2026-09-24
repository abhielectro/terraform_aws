variable "env" {}
variable "vpc_cidr" {}
variable "azs" {
    description = "Availability Zones"
    type = list(string)
}
