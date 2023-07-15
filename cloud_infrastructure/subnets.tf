resource "aws_subnet" "private-ca-central-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "ca-central-1a"

  tags = {
    "Name"                                           = "private-ca-central-1a"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "private-ca-central-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "ca-central-1b"

  tags = {
    "Name"                                           = "private-ca-central-1b"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "public-ca-central-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.64.0/19"
  availability_zone = "ca-central-1a"

  tags = {
    "Name"                                           = "public-ca-central-1a"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}

resource "aws_subnet" "public-ca-central-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.96.0/19"
  availability_zone = "ca-central-1b"

  tags = {
    "Name"                                           = "public-ca-central-1b"
    "kubernetes.io/role/elb"                         = "1"
    "kubernetes.io/cluster/kubernetes-message-board" = "owned"
  }
}
