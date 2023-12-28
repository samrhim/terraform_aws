
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "dev_public"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route_table_association" "dev_public_rt_association" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.dev_public_rt.id
}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["197.23.103.38/32", "197.92.97.26/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev_sg"
  }
}

resource "aws_key_pair" "dev_key" {
  key_name   = "dev_key"
  public_key = file(~/.ssh/mtckey.pub)
  
} 
