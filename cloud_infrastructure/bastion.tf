data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_security_group" "bastion-sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.amazon_linux_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public-ca-central-1d-bastion.id
  key_name               = "bastion-host-key"
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
}

output "public_ip" {
  value = aws_instance.bastion_host.public_ip
}
