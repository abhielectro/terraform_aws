variable "region" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(string)
}
variable "cluster_name" {}
variable "cluster_version" {}

variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "node_group_name" {}

variable "instance_types" {
  type = list(string)
}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}

variable "project_name" {
  type = string
}
variable "farget_profile_name" {}
variable "farget_namespace" {}
  