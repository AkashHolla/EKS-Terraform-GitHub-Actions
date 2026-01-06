locals {
  org="ap_medium"
  env=var.env
}
module "eks" {
  source = "../modules"

  env=var.env
  cluster_name = "${local.env}_${local.org}_${var.cluster_name}"
  cidr_block = var.vpc_cidr_block
  vpc_name = "${local.env}_${local.org}_${var.vpc_name}"
  igw_name = "${local.env}_${local.org}_${var.igw_name}"
  pub_subnet_count = var.pub_subnet_count
  pub_cidr_block = var.pub_cidr_block
  pub_availability_zone = var.pub_availability_zone
  pub_sub_name = "${local.env}_${local.org}_${var.pub_sub_name}"
  pri_sub_name = "${local.env}_${local.org}_${var.pri_sub_name}"
  pri_cidr_block = var.pri_cidr_block
  pri_availability_zone = var.pri_availability_zone
  public_rt_name = "${local.env}_${local.org}_${var.public_rt_name}"
  private_rt_name = "${local.env}_${local.org}_${var.private_rt_name}"
  eip_name = "${local.env}_${local.org}_${var.eip_name}"
  ngw_name = "${local.env}_${local.org}_${var.ngw_name}"
  eks_sg = var.eks_sg
  pri_subnet_count = var.pri_subnet_count 

  is_eks_cluster_enabled = true
  is_eks_nodegroup_enabled = true
   ondemand_instance_type = var.ondemand_instance_type
  spot_instance_type = var.spot_instance_type
  desired_capacity_on_demand = var.desired_capacity_ondemand
  min_capacity_on_demand = var.min_capacity_ondemand
  max_capacity_on_demand = var.max_capacity_ondemand
  desired_capacity_spot_node = var.desired_capacity_spot
  min_capacity_spot_node = var.min_capacity_spot
  max_capacity_spot_node = var.max_capacity_spot
  cluster_version = var.cluster_version
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access = var.endpoint_public_access
  
  addon = var.addons
}