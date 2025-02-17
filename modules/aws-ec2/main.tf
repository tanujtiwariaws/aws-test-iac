resource "aws_instance" "ec2_instance" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.subnet_id
  security_groups         = [aws_security_group.ec2_instance.name]
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name}-${var.env}-instance"
  }
}
