
resource "random_integer" "random_suffix" {
    min =1000
    max = 9999
  
}
resource "aws_iam_role" "eks-cluster-role" {
    count = var.is-eks-cluster-enabled?1:0
    name = "${local.cluster_name}-role-${random_integer.random_suffix.result}"
   assume_role_policy = jsonencode({
    Version = "2012-10-17"
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
  count      = var.is-eks-cluster-enabled ? 1 : 0
  role       = aws_iam_role.eks-cluster-role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role" "eks-nodegroup-role" {
    count = var.is-eks-nodegroup-enabled?1:0
    name = "${local.cluster_name}-nodegroup-role-${random_integer.random_suffix}"
    assume_role_policy = jsondecode({
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
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count = var.is-eks-nodegroup-enabled?1:0
  role=aws_iam_role.eks-nodegroup-role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
    count = var.is-eks-nodegroup-enabled?1:0
    policy_arn =  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks-nodegroup-role[count.index].name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
    count = var.is-eks-nodegroup-enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks-nodegroup-role[count.index].name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEBSCSIDriverPolicy" {
    count = var.is-eks-nodegroup-enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.eks-nodegroup-role[count.index].name
}
resource "aws_iam_role" "eks_oidc" {
    assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
    name = "eks-oidc"
}
resource "aws_iam_policy" "eks-oidc-policy" {
    name = "test-policy"
    policy = jsonencode({
        Statement=[{
        Action=["s3:ListAllMyBuckets","s3:GetBucketLocation","*"]
        Effect="Allow"
        Resource="*"
        }]
        Version="2012-10-07"
    })
}
resource "aws_iam_role_policy_attachment" "eks-oidc-policy-attach" {
  role       = aws_iam_role.eks_oidc.name
  policy_arn = aws_iam_policy.eks-oidc-policy.arn
}
