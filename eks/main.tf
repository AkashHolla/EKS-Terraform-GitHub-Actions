locals {
  org="ap-medium"
  env=var.env
}
module "eks" {
  source = "../modules"

  env = var.env
  cluster_name = "${local.env}-${local.org}-${var.cluster_name}"
  cidr_block = var.vpc-cidr-block
  vpc-name = "${local.env}-${local.org}-${var.vpc-name}"
  igw-name = "${local.env}-${local.org}-${var.igw-name}"
  pub-subnet-count = var.pub-subnet-count
  pub-cidr-block = var.pub-cidr-block
  pub-sub-name = "${local.env}-${local.org}-${var.pub-sub-name}"
  pub-availability-zone = var.pub-availability-zone
  pri-availability-zone = var.pri-availability-zone
  pri-cidr-block = var.pri-cidr-block
  pri-subnet-count = var.pri-subnet-count
  pri-sub-name = "${local.env}-${local.org}-${var.pri-sub-name}"
  public-rt-name = "${local.env}-${local.org}-${var.public-rt-name}"
  private-rt-name = "${local.env}-${local.org}-${var.private-rt-name}"
  eip-name = "${local.env}-${local.org}-${var.eip-name}"
  ngw-name = "${local.env}-${local.org}-${var.ngw-name}"
  eks-sg = var.eks-sg
  is-eks-cluster-enabled = true
  is-eks-nodegroup-enabled = true
  ondemand_instance_type = var.ondemand-instance-type
  spot_instance_type = var.spot-instance-type
  desired_capacity_on_demand = var.desired-capacity-ondemand
  min_capacity_on_demand = var.min-capacity-ondemand
  max_capacity_on_demand = var.max-capacity-ondemand
  min_capacity_spot_node = var.min-capacity-spot
  max_capacity_spot_node = var.max-capacity-spot
  desired_capacity_spot_node = var.desired-capacity-spot
  cluster-version = var.cluster-version
  endpoint-private-access = var.endpoint-private-access
  endpoint-public-access = var.endpoint-public-access

  addon = var.addons
}