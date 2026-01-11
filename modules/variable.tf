variable "cluster_name" { }
variable "env" { }
variable "cidr_block" { }
variable "igw_name" { }
variable "pub_subnet_count" { }
variable "pub_cidr_block" { }
variable "pub_availability_zone" { }
variable "pub_sub_name" { }
variable "pri_subnet_count" { }
variable "pri_cidr_block" { }
variable "pri_availability_zone" { }
variable "pri_sub_name" { }
variable "public_rt_name" { }
variable "eip_name" { }
variable "ngw_name" { }
variable "private_rt_name" { }
variable "eks_sg" { }
variable "is_eks_enabled" { }
variable "is_node_group_enabled" { }
variable "endpoint_private_access" { }
variable "endpoint_public_access" { }
variable "cluster_version" { }
variable "addons" { }
variable "ondemand_instance_types" { }
variable "desired_capacity_on_demand" { }
variable "max_capacity_on_demand" { }
variable "min_capacity_on_demand" { }
variable "spot_instance_types" { }
variable "desired_capacity_spot_node" { }
variable "max_capacity_spot_node" { }
variable "vpc_name" { }
variable "min_capacity_spot_node" { }
variable "is_eks_role_enabled" {
  type = bool
}

