resource "aws_eks_cluster" "eks" {
role_arn = aws_iam_role.eks_cluster_role[count.index].arn
count = var.is-eks-cluster-enabled ==true?1:0
name = var.cluster_name
version = var.cluster-version

vpc_config {
  subnet_ids = [aws_subnet.private-subnet[0].id,aws_subnet.private-subnet[1].id,aws_subnet.private-subnet[2].id]
  endpoint_private_access = var.endpoint-private-access
  endpoint_public_access = var.endpoint-public-access
  security_group_ids = [aws_security_group.eks_cluster_sg.id]

}
access_config {
  authentication_mode = "CONFIG_MAP"
  bootstrap_cluster_creator_admin_permissions = true
}
tags = {
  Name=var.cluster_name
  env=var.env
}
}
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
}

resource "aws_eks_addon" "eks_addons" {
  for_each = {for idx,addon in var.addon: idx=>addon}
  cluster_name = aws_eks_cluster.eks[0].name
  addon_name = each.value.Name
  addon_version = each.value.version

  depends_on = [ aws_eks_node_group.ondemand_node,aws_eks_node_group.spot_node ]
  
}
resource "aws_eks_node_group" "ondemand_node" {
 cluster_name = aws_eks_cluster.eks[0].name
 node_group_name = "${var.cluster_name}-ondemand-nodes"
 node_role_arn = aws_iam_role.eks_nodegroup_role[0].arn

scaling_config {
  max_size = var.max_capacity_on_demand
  min_size = var.min_capacity_on_demand
  desired_size = var.desired_capacity_on_demand
}
subnet_ids = [aws_subnet.private-subnet[0].id,aws_subnet.private-subnet[1].id,aws_subnet.private-subnet[2].id]
instance_types = var.ondemand_instance_type
capacity_type = "ON_DEMAND"
labels = {
  type="ondemand"
}
update_config {
  max_unavailable = 1
}
tags = {
  Name="${var.cluster_name}-ondemand-nodes"
}
tags_all = {
  "kubernetes.io/Cluster/${var.cluster_name}"="owned"
  "name"="${var.cluster_name}-ondemand-nodes"
}
depends_on = [ aws_eks_cluster.eks ]
}
resource "aws_eks_node_group" "spot_node" {
  cluster_name = var.cluster_name
  node_group_name = "${var.cluster_name}-spot-node"
 node_role_arn = aws_iam_role.eks_nodegroup_role[0].arn

  scaling_config {
    desired_size = var.desired_capacity_spot_node
    max_size = var.max_capacity_spot_node
    min_size = var.min_capacity_spot_node
  }
  subnet_ids = [aws_subnet.private-subnet[0].id,aws_subnet.private-subnet[1].id,aws_subnet.private-subnet[2].id]
  instance_types = var.spot_instance_type
  capacity_type = "SPOT"

  update_config {
    max_unavailable = 1
  }
  tags = {
    "Name"="${var.cluster_name}-spot-node"
  }
  tags_all = {
     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Name" = "${var.cluster_name}-ondemand-nodes"
  }
  labels = {
    type="spot"
    lifecycle="spot"
  }
  disk_size = 50
  depends_on = [ aws_eks_cluster.eks ]
}
