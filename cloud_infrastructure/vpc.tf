resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/22"

  tags = {
    Name = "vpc"
  }
}
