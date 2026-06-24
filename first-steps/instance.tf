provider "aws" {
  profile = "bong9kim"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type.example

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = aws_key_pair.mykey.key_name
  tags = {
    Name = "web"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "demo-mykey"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINVr2YUDZPgv1W5xOx6q4VTnOamg9Q8go281Eez4+94A kimtaehoon@smilegate.com"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
