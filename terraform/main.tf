provider "aws" {
  region = var.region
}

resource "aws_vpc" "leumi_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "leumi-a" {
  vpc_id            = aws_vpc.leumi_vpc.id
  cidr_block        = var.subnet_a
  availability_zone = var.AZ_a

  tags = {
    Name = "${var.vpc-name}-a"
  }
}

resource "aws_subnet" "leumi-b" {
  vpc_id            = aws_vpc.leumi_vpc.id
  cidr_block        = var.subnet_b
  availability_zone = var.AZ_b

  tags = {
    Name = "${var.vpc-name}-b"
  }
}

resource "aws_security_group" "sg-Leumi" {
  name_prefix = "apache-sg"
  vpc_id = aws_vpc.leumi_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.Leumi_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "Leumi-1" {
  ami                         = "ami-0c0933ae5caf0f5f9"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.leumi-a.id
  key_name                    = "My-Leumi"
  security_groups             = [aws_security_group.sg-Leumi.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              echo "Leumi Project" > /var/www/html/index.html
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
  tags = {
    Name = "Leumi-instance"
  }
}
resource "aws_eip" "Leumi-eip" {
  instance = aws_instance.Leumi-1.id
  vpc      = true
}
# resource "aws_network_interface_attachment" "ec2_eip_attachment" {
#   instance_id          = aws_instance.Leumi-1.id
#   network_interface_id = aws_instance.Leumi-1.network_interface_id
#   device_index         = 0
# }

resource "aws_eip_association" "ec2_eip_association" {
  instance_id   = aws_instance.Leumi-1.id
  allocation_id = aws_eip.Leumi-eip.id
}
resource "aws_internet_gateway" "Leumi-igw" {
  vpc_id = aws_vpc.leumi_vpc.id

  tags = {
    Name = "Leumi-igw"
  }
}
resource "aws_route_table" "leumi_public_rt" {
  vpc_id = aws_vpc.leumi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Leumi-igw.id
  }

  tags = {
    Name = "leumi_public_rt"
  }
}

resource "aws_route_table_association" "leumi_subnet_a_public" {
  subnet_id      = aws_subnet.leumi-a.id
  route_table_id = aws_route_table.leumi_public_rt.id
}

resource "aws_route_table_association" "leumi_subnet_b_public" {
  subnet_id      = aws_subnet.leumi-b.id
  route_table_id = aws_route_table.leumi_public_rt.id
}
