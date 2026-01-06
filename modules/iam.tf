
resource "random_integer" "random_suffix" {
    min =1000
    max = 9999
  
}
resource "aws_iam_role" "eks_cluster_role" {
    count = var.is_eks_cluster_enabled?1:0
    name = "${local.cluster_name}_role_${random_integer.random_suffix.result}"
   assume_role_policy = jsonencode({
    Version = "2012_10_17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count      = var.is_eks_cluster_enabled ? 1 : 0
  role       = aws_iam_role.eks_cluster_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role" "eks_nodegroup_role" {
    count = var.is_eks_nodegroup_enabled?1:0
    name = "${local.cluster_name}_nodegroup_role_${random_integer.random_suffix}"
    assume_role_policy = jsondecode({
        Version = "2012_10_17"
  Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
      Service = "ec2.amazonaws.com"
    }
  }]
})
}
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count = var.is_eks_nodegroup_enabled?1:0
  role=aws_iam_role.eks_nodegroup_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
    count = var.is_eks_nodegroup_enabled?1:0
    policy_arn =  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks_nodegroup_role[count.index].name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
    count = var.is_eks_nodegroup_enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks_nodegroup_role[count.index].name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEBSCSIDriverPolicy" {
    count = var.is_eks_nodegroup_enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/service_role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.eks_nodegroup_role[count.index].name
}
resource "aws_iam_role" "eks_oidc" {
    assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
    name = "eks_oidc"
}
resource "aws_iam_policy" "eks_oidc_policy" {
    name = "test_policy"
    policy = jsonencode({
        Statement=[{
        Action=["s3:ListAllMyBuckets","s3:GetBucketLocation","*"]
        Effect="Allow"
        Resource="*"
        }]
        Version="2012_10_07"
    })
}
resource "aws_iam_role_policy_attachment" "eks_oidc_policy_attach" {
  role       = aws_iam_role.eks_oidc.name
  policy_arn = aws_iam_policy.eks_oidc_policy.arn
}
