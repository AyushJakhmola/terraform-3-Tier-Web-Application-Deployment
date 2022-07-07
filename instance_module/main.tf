resource "aws_security_group" "public_sg" {
  vpc_id = var.sample_vpc_id
  dynamic "ingress" {
    for_each = var.inbound_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = var.inbound_protocol
      cidr_blocks = local.anywhere
    }
  }
  tags = {
    Name = "allow_tls"
  }
}
resource "aws_instance" "bastion" {
  ami                         = var.instance_ami
  instance_type               = var.aws_instance_type
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = var.aws_public_subnet_ids[0]
  key_name                    = var.instance_key_name
  associate_public_ip_address = var.associate_public_ip_address
  tags = {
    Name = "sample"
  }
}