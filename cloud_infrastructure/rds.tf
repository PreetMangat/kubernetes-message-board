resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = [aws_subnet.public-ca-central-1d-bastion.cidr_block, aws_subnet.private-ca-central-1a.cidr_block, aws_subnet.private-ca-central-1b.cidr_block]
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private-ca-central-1d-rds.id, aws_subnet.private-ca-central-1b-rds.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mysql-db" {
  allocated_storage      = 5
  db_name                = "mydb"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "foo"
  password               = "foobarbaz"
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
}

