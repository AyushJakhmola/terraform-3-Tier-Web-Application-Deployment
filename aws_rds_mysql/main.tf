
resource "aws_security_group" "db_sg" {
  vpc_id = var.sample_vpc_id
  dynamic "ingress" {
    for_each = var.db_inbound_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = var.inbound_protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "db_sg"
  }
}
resource "aws_db_subnet_group" "dbSubnetGroup" {
  
  name        = "db-subnet-group"
  subnet_ids  = var.aws_private_subnet_ids[*]

  tags = {
    Name = "db-subnet-group"
  }
}
resource "aws_db_instance" "default" {

  allocated_storage    = var.volume
  engine               = var.DBEngine
  engine_version       = var.EngineVersion
#  username             = var.dbUserPassword.User_name
#  password             = var.dbUserPassword.Password
  username             = var.username
  password             = var.password
  db_name          = var.my_db_name
  skip_final_snapshot  = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = false 
  backup_retention_period = 0
  db_subnet_group_name = aws_db_subnet_group.dbSubnetGroup.name
  instance_class = var.InstanceClass
  vpc_security_group_ids = [aws_security_group.db_sg.id] 

}