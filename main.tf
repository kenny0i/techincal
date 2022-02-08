#Create a VPC
resource "aws_vpc" "hest_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "hest_vpc"
  }
}

#Public Subnet 01
resource "aws_subnet" "hest-public-subnet" {
  vpc_id            = aws_vpc.hest_vpc.id
  cidr_block        = var.pub_cidr
  availability_zone = var.az_1 #Attached  availability zone for high availability

  tags = {
    Name = "hest-public-subnet"
  }
}

#Private 01
resource "aws_subnet" "hest-private-subnet" {
  vpc_id            = aws_vpc.hest_vpc.id
  cidr_block        = var.prv_cidr
  availability_zone = var.az_2 #Attached  availability zone for high availability

  tags = {
    Name = "hest-private-subnet"
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "Hest-IGW" {
  vpc_id = aws_vpc.hest_vpc.id

  tags = {
    Name = "Hest-IGW"
  }
}
#Create Elastic Ip for Nat Gateway
resource "aws_eip" "hest-eip" {
  vpc = true
}

#Create a NAT Gateway
resource "aws_nat_gateway" "Hest-NAT" {
  allocation_id = aws_eip.hest-eip.id
  subnet_id     = aws_subnet.hest-public-subnet.id

  tags = {
    Name = "Hest-NAT"
  }
}

#Create a Public Route Table
resource "aws_route_table" "Hest-Pub-RT" {
  vpc_id = aws_vpc.hest_vpc.id

  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.Hest-IGW.id
  }

  tags = {
    Name = "Hest-Pub-RT"
  }
}

#Create a Private Route Table
resource "aws_route_table" "Hest-Prv-RT" {
  vpc_id = aws_vpc.hest_vpc.id

  route {
    cidr_block     = var.all_cidr
    nat_gateway_id = aws_nat_gateway.Hest-NAT.id
  }

  tags = {
    Name = "Hest-Prv-RT"
  }
}

#Associate Pub Subnet to Pub RT
resource "aws_route_table_association" "Hest-Pub-Association" {
  subnet_id      = aws_subnet.hest-public-subnet.id
  route_table_id = aws_route_table.Hest-Pub-RT.id
}

#Associate Prv Subnet to Prv RT
resource "aws_route_table_association" "Hest-Prv-Association" {
  subnet_id      = aws_subnet.hest-private-subnet.id
  route_table_id = aws_route_table.Hest-Prv-RT.id
}

# Create a Frontend Security Groups 
resource "aws_security_group" "hest_frontend_sg" {
  name        = "hest_frontend_sg"
  description = "public security group"
  vpc_id      = aws_vpc.hest_vpc.id

  ingress {
    description = "Allow port for http"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.my_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "hest_frontend_sg"
  }
}

# Create a Backend Security Groups 
resource "aws_security_group" "hest_backend_sg" {
  name        = "hest_backend_sg"
  description = "private security group"
  vpc_id      = aws_vpc.hest_vpc.id

  ingress {
    description = "Allow port for http"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.pub_cidr] # Only allow access from public subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr] # All traffics coming in should go out
  }

  tags = {
    Name = "hest_backend_sg"
  }
}

#Create a WEB Server in Public Subnet
resource "aws_instance" "WEB_Server" {
  ami                         = var.ami
  instance_type               = var.instance_tpye
  availability_zone           = var.az_1
  subnet_id                   = aws_subnet.hest-public-subnet.id
  vpc_security_group_ids      = ["${aws_security_group.hest_frontend_sg.id}"]
  associate_public_ip_address = true

  tags = {
    Name = "Web_Server"
  }
}

#Create a Database Server in Private Subnet
resource "aws_instance" "Mysql_Server" {
  ami                         = var.ami
  instance_type               = var.instance_tpye
  availability_zone           = var.az_2
  subnet_id                   = aws_subnet.hest-private-subnet.id
  vpc_security_group_ids      = ["${aws_security_group.hest_backend_sg.id}"]
  associate_public_ip_address = true

  tags = {
    Name = "Mysql_Server"
  }
}