resource "aws_instance" "web-server" {
  depends_on = [aws_vpc.web-app-vpc, aws_internet_gateway.web-app-igw, aws_route_table.web-app-route-table, aws_subnet.web-app-public-subnet, aws_security_group.web-server-allow-http-sg]

  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.web-app-public-subnet.id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.web-server-allow-http-sg.id]

  user_data = <<EOF
    #!/bin/bash
    # Update the system packages
    sudo apt-get update -y

    # Install Nginx
    sudo apt-get install -y nginx

    # Start the Nginx service
    sudo systemctl start nginx
    EOF

  tags = {
    Name = "web-server"
  }
}
