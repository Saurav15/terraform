resource "aws_security_group" "web-server-allow-http-sg" {
  depends_on  = [aws_vpc.web-app-vpc]
  name        = "allow_http_80"
  description = "Allow traffic from 0.0.0.0 to port 80."
  vpc_id      = aws_vpc.web-app-vpc.id

  tags = {
    Name = "allow_http"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web-server-allow-http-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.web-server-allow-http-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_http" {
  security_group_id = aws_security_group.web-server-allow-http-sg.id
  ip_protocol       = "TCP"
  from_port         = 80
  cidr_ipv4         = "0.0.0.0/0"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_https" {
  security_group_id = aws_security_group.web-server-allow-http-sg.id
  ip_protocol       = "TCP"
  from_port         = 443
  cidr_ipv4         = "0.0.0.0/0"
  to_port           = 443
}
