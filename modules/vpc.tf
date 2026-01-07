locals {
  cluster_name=var.cluster_name
}
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name=var.vpc-name
        env=var.env
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name=var.igw-name
        env=var.env
        "kubernetes.io/cluster/${local.cluster_name}"= "owned"
    }
    depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = element(var.pub-cidr-block,count.index)
    count = var.pub-subnet-count
    availability_zone = element(var.pub-availability-zone,count.index)
    map_public_ip_on_launch = true

    tags = {
      Name="${var.pub-sub-name}-${count.index+1}"
      env=var.env
      "kubernetes.io/cluster/${local.cluster_name}"="owned"
      "kubernetes.io/role/elb"="1"
    }
    depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pri-cidr-block,count.index)
  count = var.pri-subnet-count
  availability_zone = element(var.pri-availability-zone,count.index)
  map_public_ip_on_launch = false

  tags = {
    Name="${var.pri-sub-name}-${count.index+1}"
    env=var.env
    "kubernetes.io/cluster/${local.cluster-name}"="owned"
    "kubernetes.io/role/elb"="1"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id 
    }
    tags = {
      Name=var.public-rt-name
      env=var.env
    }
    depends_on = [ aws_vpc.vpc ]
}
resource "aws_route_table_association" "name" {
    route_table_id = aws_route_table.public_rt.id
    count = 3
    subnet_id = aws_subnet.public-subnet[count.index].id

    depends_on = [ aws_vpc.vpc,aws_subnet.public-subnet ] 
}

resource "aws_eip" "ngw-eip" {
    domain = "vpc"
    tags = {
        Name=var.eip-name
    }
    depends_on = [ aws_vpc.vpc ]
  
}
resource "aws_nat_gateway" "ngw" {
    subnet_id = aws_subnet.public-subnet[0].id
    allocation_id = aws_eip.ngw-eip.id

    tags = {
        Name=var.ngw-name
    }
    depends_on = [ aws_vpc.vpc,aws_eip.ngw-eip ]
}
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id
    route  {
        cidr_block="0.0.0.0/0"
        nat_gateway_id= aws_nat_gateway.ngw.id  
    }
    tags = {
      Name = var.private-rt-name
      env=var.env
    }
    depends_on = [ aws_vpc.vpc ]
}
resource "aws_route_table_association" "pri-rt-association" {
    route_table_id = aws_route_table.private_rt.id
    count = 3
    subnet_id = aws_subnet.public-subnet[count.index].id 

    depends_on = [ aws_vpc.vpc,aws_subnet.private-subnet ]
  
}
resource "aws_security_group" "eks_cluster_sg" {
  name = var.eks-sg
  description = "Allow 443 from jump server"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port=443
    to_port=443
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
  tags = {
    Name=var.eks-sg
  }
}