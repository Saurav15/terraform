# Create a VPC
resource "aws_vpc" "web-app-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web-app-vpc"
  }
}

# Create 2 subnets.
resource "aws_subnet" "web-app-public-subnet" {
  vpc_id     = aws_vpc.web-app-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "web-app-public-subnet"
  }
}

resource "aws_subnet" "web-app-private-subnet" {
  vpc_id     = aws_vpc.web-app-vpc.id
  cidr_block = "10.0.8.0/24"

  tags = {
    Name = "web-app-private-subnet"
  }
}

# Create an internet gateway.
resource "aws_internet_gateway" "web-app-igw" {
  vpc_id = aws_vpc.web-app-vpc.id

  tags = {
    Name = "web-app-igw"
  }
}

# # Create a NAT Gateway
# resource "aws_nat_gateway" "web-app-natg" {
#   subnet_id = aws_subnet.web-app-public-subnet.id
# }

# Create a route table for public subnet.
resource "aws_route_table" "web-app-route-table" {
  vpc_id = aws_vpc.web-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-app-igw.id
  }
}

# Associate public subnet with this route table
resource "aws_route_table_association" "rt-associate" {
  route_table_id = aws_route_table.web-app-route-table.id
  subnet_id      = aws_subnet.web-app-public-subnet.id
}
