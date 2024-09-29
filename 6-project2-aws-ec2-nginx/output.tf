output "ec2-url" {
  depends_on = [aws_instance.web-server]
  value      = aws_instance.web-server.public_ip
}
