resource "aws_instance" "web_server" {
  ami                         = "ami-05ffe3c48a9991133"
  instance_type               = "m7i-flex.large"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "${var.project_name}-server"
  }
}
