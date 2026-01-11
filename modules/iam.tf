locals {
  cluster_name=var.cluster_name
}
resource "random_integer" "random_suffix" {
    min = 1000
    max = 9999
}
resource "aws_iam_role" "eks_cluster_role" {
    count = var.is_eks_enabled?1:0
    name = "${local.cluster_name}-role-${random_integer.random_suffix.result}"
    assume_role_policy = jsonencode({
          Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    count = var.is_eks_enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_role[count.index].name
}
resource "aws_iam_role" "eks_nodegroup_role" {
    count = var.is_eks_enabled?1:0
    name = "${local.cluster_name}-nodegroup-role-${random_integer.random_suffix.result}"
  assume_role_policy = jsonencode({
     Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "eks_AmazonWorkerNodePolicy" {  //policy for  workernode 
    count = var.is_eks_enabled?1:0
    role = aws_iam_role.eks_nodegroup_role[count.index].name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {  //policy for pulling image from ECR
    count = var.is_eks_enabled?1:0
    role = aws_iam_role.eks_nodegroup_role[count.index].name
    policy_arn =  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEBSCSIDriverPolicy" { //policy to create PV for Nodes
    count = var.is_eks_enabled?1:0
    role = aws_iam_role.eks_nodegroup_role[count.index].name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  
}

resource "aws_iam_role" "eks_oidc" {
    assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
    name = "eks_oidc"
}
resource "aws_iam_policy" "eks_oidc_policy" {
    name = "test-policy"
    policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation",
        "*"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
  
}
resource "aws_iam_role_policy_attachment" "eks_oidc_policy_attach" {
    role = aws_iam_policy.eks_oidc_policy.name
    policy_arn = aws_iam_policy.eks_oidc_policy.arn
  
}