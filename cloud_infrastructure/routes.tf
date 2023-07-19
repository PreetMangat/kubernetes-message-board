resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public-ca-central-1a" {
  subnet_id      = aws_subnet.public-ca-central-1a.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public-ca-central-1b" {
  subnet_id      = aws_subnet.public-ca-central-1b.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public-ca-central-1d-bastion" {
  subnet_id      = aws_subnet.public-ca-central-1d-bastion.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private-ca-central-1a" {
  subnet_id      = aws_subnet.private-ca-central-1a.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_route_table_association" "private-ca-central-1b" {
  subnet_id      = aws_subnet.private-ca-central-1b.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
