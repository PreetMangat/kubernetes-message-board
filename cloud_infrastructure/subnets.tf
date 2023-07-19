resource "aws_subnet" "public-ca-central-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "ca-central-1a"

  tags = {
    "Name"                                           = "public-ca-central-1a"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "public-ca-central-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.64/26"
  availability_zone = "ca-central-1b"

  tags = {
    "Name"                                           = "public-ca-central-1b"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "public-ca-central-1d-bastion" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.128/26"
  availability_zone       = "ca-central-1d"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-ca-central-1d-bastion"
  }
}

resource "aws_subnet" "private-ca-central-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.192/26"
  availability_zone = "ca-central-1a"

  tags = {
    "Name"                                           = "private-ca-central-1a"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "private-ca-central-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/26"
  availability_zone = "ca-central-1b"

  tags = {
    "Name"                                           = "private-ca-central-1b"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "private-ca-central-1d-rds" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.64/26"
  availability_zone = "ca-central-1d"

  tags = {
    "Name" = "private-ca-central-1d-rds"
  }
}

resource "aws_subnet" "private-ca-central-1b-rds" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.128/26"
  availability_zone = "ca-central-1b"

  tags = {
    "Name" = "private-ca-central-1b-rds"
  }
}
