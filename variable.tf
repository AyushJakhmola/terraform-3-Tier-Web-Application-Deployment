variable "aws_region" {
  default = "ap-south-1"
}
variable "instance_type" {
  default = "t3a.micro"
}
variable "inbound_ports" {
  default = [22,80]
}
variable "instance_key_name" {
  default = "microservices"
}

variable "alb_inbound_ports" {
  default = [80,443]
}

#  type = object({
#    User_name = "mysql"
#    Password = "mysql@50"
#  })
#}

variable "db_inbound_ports" {
  default = [3306]
}