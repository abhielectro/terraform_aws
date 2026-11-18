variable "env" {
  type = string
}
variable "cluster_name" {
    type = string
}

variable "cluster_version" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "node_group_name" {
    type = string
}

variable "instance_types" {
    type = list(string)
}

variable "desired_size" {
    type = number
}

variable "min_size" {
    type = number
}

variable "max_size" {
    type = number
}
variable "enable_fargate" {
  description = "Enable or disable EKS Fargate Profile"
  type        = bool
  default     = false
}
variable "fargate_profile_name" {
    type = string
}

variable "fargate_namespace" {
    type = string
}
variable "project_name" {
  type = string
}