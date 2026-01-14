variable "env" { type = string }
variable "aws_region" { type = string }
variable "cluster_name" { type = string }

variable "vpc_cidr_block" { type = string }
variable "vpc_name" { type = string }
variable "igw_name" { type = string }

variable "pub_subnet_count" { type = number }
variable "pub_cidr_block" { type = list(string) }
variable "pub_availability_zone" { type = list(string) }
variable "pub_sub_name" { type = string }

variable "pri_subnet_count" { type = number }
variable "pri_cidr_block" { type = list(string) }
variable "pri_availability_zone" { type = list(string) }
variable "pri_sub_name" { type = string }

variable "public_rt_name" { type = string }
variable "private_rt_name" { type = string }
variable "eip_name" { type = string }
variable "ngw_name" { type = string }
variable "eks_sg" { type = string }

variable "is_eks_enabled" { type = bool }
variable "cluster_version" { type = string }
variable "endpoint_private_access" { type = bool }
variable "endpoint_public_access" { type = bool }

variable "ondemand_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "spot_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "desired_capacity_on_demand" { type = number }
variable "min_capacity_on_demand"     { type = number }
variable "max_capacity_on_demand"     { type = number }

variable "desired_capacity_spot_node" { type = number }
variable "min_capacity_spot_node"     { type = number }
variable "max_capacity_spot_node"     { type = number }

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = []
}

