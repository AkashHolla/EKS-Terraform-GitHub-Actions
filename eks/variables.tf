variable "aws_region" {  }
variable "env" {  }
variable "vpc-name" {  }
variable "vpc-cidr-block" {  }
variable "igw-name" {  }
variable "pub-subnet-count" {  }
variable "pub-cidr-block" {
    type = list(string)
} 
variable "pub-availability-zone" {
    type = list(string)
} 
variable "pub-sub-name" {}  
variable "pri-subnet-count" {  }
variable "pri-cidr-block" {
    type = list(string)
} 
variable "pri-availability-zone" {
    type = list(string)
} 
variable "pri-sub-name" {}  
variable "public-rt-name" {}  
variable "private-rt-name" {}  
variable "eip-name" {}  
variable "ngw-name" {}  
variable "eks-sg" {}  

variable "is-eks-cluster-enabled" { }
variable "cluster-version" { }
variable "cluster-name" {}
variable "endpoint-private-access" { }
variable "endpoint-public-access" { }
variable "ondemand-instance-type" {
  default = ["t3a.medium"]
}
variable "desired-capacity-ondemand" {}
variable "min-capacity-ondemand" {}
variable "max-capacity-ondemand" {}
variable "spot-instance-type" {}
variable "desired-capacity-spot" {}
variable "min-capacity-spot" {}
variable "max-capacity-spot" {}
variable "addons" {
  type = list(object({
    name=string
    version=string
  }))
}