terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# Create a VPC with a given CIDR block 10.0.0.0/16
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

# Create 2 subnets 1. Public(10.0.1.0/24) and 2. Private (10.0.2.0/24)
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# Create an internet gateway.
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

# Create a route table, create a route for public subnet and route all the destination requests for 0.0.0.0/0 to the internet gateway.
# Create a route table and add a route 
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "terraform-public-route-table"
  }
}

# Associate the public subnet with this route table
resource "aws_route_table_association" "associate-public-subnet-with-routetable" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}


# Create 2 instance 1.public ec2 
resource "aws_instance" "public-instance-webapp" {
  ami                         = "ami-0ebfd941bbafe70c6"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
}
