module "vpc" {

  source              = "./vpc_module/"
  vpc_cidr            = var.vpc_cidr
  aws-region          = "var.aws_region"
  #public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  PublicSubnetCount = var.PublicSubnetCount
  CidrBits = var.CidrBits
  #private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
  PrivateSubnetCount = var.PrivateSubnetCount
}

module "instance" {

  source                      = "./instance_module/"
  sample_vpc_id               = module.vpc.vpc_id
  aws_public_subnet_ids       = module.vpc.public_subnet_ids
  aws_private_subnet_ids      = module.vpc.private_subnet_ids
  instance_ami                = var.instance_ami 
  aws_instance_type           = var.instance_type
  inbound_ports               = var.inbound_ports
  instance_key_name           = var.instance_key_name
  associate_public_ip_address = var.associate_public_ip_address 

}

module "alb" {
 
  source = "./aws_alb_module"
  sample_vpc_id = module.vpc.vpc_id
  alb_inbound_ports = var.alb_inbound_ports
  aws_public_subnet_ids = module.vpc.public_subnet_ids 
  instance_id = module.instance.instance_id
  instance_ami = var.instance_ami
  asgInstanceType = var.asgInstanceType
  instance_key_name = var.instance_key_name
  instance_sg = module.instance.instance_sg
}

module "rds_db_mysql" {
 
  source = "./aws_rds_mysql"
  sample_vpc_id               = module.vpc.vpc_id
  db_inbound_ports = var.db_inbound_ports
  aws_private_subnet_ids = module.vpc.private_subnet_ids
#  dbUserPassword = var.dbUserPassword
#  username             = "db_mysql"
#  password             = "mysql123"
  dbUsernamePassword = var.dbUsernamePassword
  DBEngine = "mysql"
  EngineVersion = "8.0.28"
  my_db_name = "mysql007"
  InstanceClass = "db.t3.micro"
  volume = 8
}