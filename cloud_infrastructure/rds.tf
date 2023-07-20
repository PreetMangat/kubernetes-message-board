##############################################################################
#                       Security Groups / Subnet Group
##############################################################################

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = [aws_subnet.public_ca_central_1d_bastion.cidr_block, aws_subnet.private_ca_central_1a.cidr_block, aws_subnet.private_ca_central_1b.cidr_block]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private_ca_central_1d_rds.id, aws_subnet.private_ca_central_1b_rds.id]
}

##############################################################################
#                         Database (MySQL RDS)
##############################################################################

resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 5
  db_name                = "mydb"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "foo"
  password               = "foobarbaz"
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}
