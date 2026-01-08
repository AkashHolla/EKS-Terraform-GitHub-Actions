
resource "random_integer" "random_suffix" {
    min =1000
    max = 9999
  
}
resource "aws_iam_role" "eks_cluster_role" {
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
  role       = aws_iam_role.eks_cluster_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role" "eks_nodegroup_role" {
    count = var.is-eks-nodegroup-enabled?1:0
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
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count = var.is-eks-nodegroup-enabled?1:0
  role=aws_iam_role.eks_nodegroup_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
    count = var.is-eks-nodegroup-enabled?1:0
    policy_arn =  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks_nodegroup_role[count.index].name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
    count = var.is-eks-nodegroup-enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks_nodegroup_role[count.index].name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEBSCSIDriverPolicy" {
    count = var.is-eks-nodegroup-enabled?1:0
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.eks_nodegroup_role[count.index].name
}
resource "aws_iam_role" "eks_oidc" {
    assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
    name = "eks-oidc"
}
resource "aws_iam_policy" "eks_oidc_policy" {
  name = "test-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_oidc_policy_attach" {
  role       = aws_iam_role.eks_oidc.name
  policy_arn = aws_iam_policy.eks_oidc_policy.arn
}
data "tls_certificate" "eks" {
  url =aws_eks_cluster.eks[0].identity[0].oidc[0].issuer

}

resource "aws_iam_role_policy_attachment" "eks_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.eks_nodegroup_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
