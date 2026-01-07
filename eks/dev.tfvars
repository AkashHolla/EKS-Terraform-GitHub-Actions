env ="dev"
aws_region ="us-east-1"
vpc-cidr-block = "10.16.0.0/16"
vpc-name = "vpc"
igw-name = "igw "
pub-subnet-count = "3"
pub-cidr-block = [ "10.16.0.0/20","10.16.16.0/20","10.16.32.0/20" ]
pub-availability-zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
pub-sub-name = "subnet-public"
pri-subnet-count = 3
pri-cidr-block = [ "10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20" ]
pri-availability-zone = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
pri-sub-name = "subnet-private"
public-rt-name = "public-route-table"
private-rt-name = "private-route-table"
eip-name = "elasticip-ngw"
ngw-name = "ngw"
eks-sg = "eks-sg"

is-eks-cluster-enabled = true
cluster-version = "1.33"
cluster_name ="eks-cluster"
endpoint-public-access = false
endpoint-private-access = true
ondemand-instance-type = ["t3.micro"]
spot-instance-type = ["t3.micro"]
desired-capacity-spot  = "1" 
min-capacity-spot = "1"
max-capacity-spot = "10"
desired-capacity-ondemand = "1"
min-capacity-ondemand = "1"
max-capacity-ondemand = "5"
addons = [ {
  name = "vpc-cni",
  version = "v1.20.0-eksbuild.1"
},
{
 name = "coredns"
    version = "v1.12.2-eksbuild.4"
},
{
     name    = "kube-proxy"
    version = "v1.33.0-eksbuild.2"
},
{
     name    = "aws-ebs-csi-driver"
    version = "v1.46.0-eksbuild.1"
} ]
