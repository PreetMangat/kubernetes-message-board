##############################################################################
#                                VPC, IGW, NAT
##############################################################################

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/22"

  tags = {
    Name = "vpc-kubernetes-message-board"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-kubernetes-message-board"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_ca_central_1b.id

  tags = {
    Name = "nat-kubernetes-message-board"
  }

  depends_on = [aws_internet_gateway.igw]
}

##############################################################################
#                                Subnets
##############################################################################

resource "aws_subnet" "public_ca_central_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "ca-central-1a"

  tags = {
    "Name"                                           = "public_ca_central_1a"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "public_ca_central_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.64/26"
  availability_zone = "ca-central-1b"

  tags = {
    "Name"                                           = "public_ca_central_1b"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "public_ca_central_1d_bastion" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.128/26"
  availability_zone       = "ca-central-1d"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public_ca_central_1d_bastion"
  }
}

resource "aws_subnet" "private_ca_central_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.192/26"
  availability_zone = "ca-central-1a"

  tags = {
    "Name"                                           = "private_ca_central_1a"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "private_ca_central_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/26"
  availability_zone = "ca-central-1b"

  tags = {
    "Name"                                           = "private_ca_central_1b"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "private_ca_central_1d_rds" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.64/26"
  availability_zone = "ca-central-1d"

  tags = {
    "Name" = "private-ca-central-1d-rds"
  }
}

resource "aws_subnet" "private_ca_central_1b_rds" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.128/26"
  availability_zone = "ca-central-1b"

  tags = {
    "Name" = "private_ca_central_1b-rds"
  }
}

##############################################################################
#                                Routes
##############################################################################

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_ca_central_1a" {
  subnet_id      = aws_subnet.public_ca_central_1a.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_ca_central_1b" {
  subnet_id      = aws_subnet.public_ca_central_1b.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_ca_central_1d_bastion" {
  subnet_id      = aws_subnet.public_ca_central_1d_bastion.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_ca_central_1a" {
  subnet_id      = aws_subnet.private_ca_central_1a.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_route_table_association" "private_ca_central_1b" {
  subnet_id      = aws_subnet.private_ca_central_1b.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
