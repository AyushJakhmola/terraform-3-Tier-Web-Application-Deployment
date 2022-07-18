variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "aws_region" {
  default = "ap-south-1"
}
variable "PublicSubnetCount" {
  default = 2
}
variable "PrivateSubnetCount" {
  default = 2
}
variable "CidrBits" {
  default = 4
}
variable "PrivSubnetCount" {
  default = 2
}
variable "instance_type" {
  default = "t3a.micro"
}
variable "instance_key_name" {
  default = "microservices"
}
variable "instance_ami" {
  default = "ami-006d3995d3a6b963b"
}
variable "associate_public_ip_address" {
  default = "true"
}
variable "inbound_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
    CidrBlock = string
  }))
  default = [
    {
      internal = 22
      external = 22
      protocol = "ssh"
      CidrBlock = "0.0.0.0/0"
    },
        {
      internal = 80
      external = 80
      protocol = "tcp"
      CidrBlock = "0.0.0.0/0"
    }
  ]
}


variable "alb_inbound_ports" {
   type = list(object({
    internal = number
    external = number
    protocol = string
    CidrBlock = string
  }))
  default = [
    {
      internal = 443
      external = 443
      protocol = "https"
      CidrBlock = "0.0.0.0/0"
    },
        {
      internal = 80
      external = 80
      protocol = "http"
      CidrBlock = "0.0.0.0/0"
    }
  ]
}
variable "db_inbound_ports" {
   type = list(object({
    internal = number
    external = number
    protocol = string
    CidrBlock = string
  }))
  default = [
    {
      internal = 443
      external = 443
      protocol = "https"
      CidrBlock = "0.0.0.0/0"
    },
        {
      internal = 80
      external = 80
      protocol = "http"
      CidrBlock = "0.0.0.0/0"
    }
  ]
}
variable "dbUsernamePassword" {
   type = list(object({
    User_name = string
    Password = string
  }))
  default = [
    {
      User_name = "mysql"
      Password = "mysql@50"
    }
  ]
}
variable "asgInstanceType" {
  default = "t3a.micro"
}