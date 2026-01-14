
resource "aws_eks_cluster" "eks" {
  count = var.is_eks_enabled ? 1 : 0

  name    = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role[0].arn

  vpc_config {
    subnet_ids              = aws_subnet.private_subnet[*].id
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  access_config {
    authentication_mode = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = var.cluster_name
    env  = var.env
  }
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = data.tls_certificate.eks_certificate.url  
  client_id_list = ["sts.amazonaws.com"]  
  thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
}

resource "aws_eks_node_group" "ondemand_node" {
  cluster_name  = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster_name}-ondemand-nodes"
  node_role_arn = aws_iam_role.eks_nodegroup_role[0].arn

  subnet_ids = aws_subnet.private_subnet[*].id

  instance_types = var.ondemand_instance_types
  capacity_type  = "ON_DEMAND"

  scaling_config {
    min_size     = var.min_capacity_on_demand
    max_size     = var.max_capacity_on_demand
    desired_size = var.desired_capacity_on_demand
  }

  update_config { max_unavailable = 1 }

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.eks_AmazonWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_AmazonEBSCSIDriverPolicy
  ]
}

resource "aws_eks_node_group" "spot_node" {
  cluster_name  = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster_name}-spot-nodes"
  node_role_arn = aws_iam_role.eks_nodegroup_role[0].arn

  subnet_ids = aws_subnet.private_subnet[*].id

  instance_types = var.spot_instance_types
  capacity_type  = "SPOT"

  scaling_config {
    min_size     = var.min_capacity_spot_node
    max_size     = var.max_capacity_spot_node
    desired_size = var.desired_capacity_spot_node
  }

  update_config { max_unavailable = 1 }

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.eks_AmazonWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_AmazonEBSCSIDriverPolicy
  ]
}

resource "aws_eks_addon" "addons" {
  for_each     = { for idx, addon in var.addons : idx => addon }
  cluster_name = aws_eks_cluster.eks[0].name
  addon_name   = each.value.name
  addon_version = each.value.version

  depends_on = [aws_eks_cluster.eks]
}
