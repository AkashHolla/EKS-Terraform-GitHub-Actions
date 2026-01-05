locals {
  cluster-name=var.cluster-name
}
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = default
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name=var.vpc-name
        env=var.env
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc-id

    tags = {
        Name=var.igw-name
        env=var.env
        "kubernetes.io/cluster/${local.cluster-name}"= "owned"
    }
    depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = element(var.pub-cidr-block,count.index)
    count = var.pub-subnet-count
    availability_zone = element(var.pub-availability-zone,count.index)
  
}