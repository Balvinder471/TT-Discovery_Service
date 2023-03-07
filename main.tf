data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "http" {
  name = "allow-http"
  description = "Allow http in and all out"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "http_in" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.http.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_out" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.http.id
  to_port           = 0
  type              = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}