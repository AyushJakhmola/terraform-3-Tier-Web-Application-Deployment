#creating vpc 
resource "aws_vpc" "sample_project" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "sample"
  }
}

#creating internet gateway for public subnets
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_project.id
}

#creating nat gateway
resource "aws_eip" "sample-nat" {
  vpc = true
}
resource "aws_nat_gateway" "sample_ngw" {
  allocation_id = aws_eip.sample-nat.id
  subnet_id     = aws_subnet.public_vpc_subnet[0].id
  tags = {
    Name = "sample_NATgw"
  }
}
#creating public subnets
resource "aws_subnet" "public_vpc_subnet" {
  count             = var.PublicSubnetCount
  vpc_id            = aws_vpc.sample_project.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.CidrBits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnets-${data.aws_availability_zones.available.names[count.index]}"
  }
}
#creating private subnets
resource "aws_subnet" "private_vpc_subnet" {
  count             = var.PrivateSubnetCount
  vpc_id            = aws_vpc.sample_project.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.CidrBits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnets-${data.aws_availability_zones.available.names[count.index]}"
  }
}

#creating route tables for public subnet 
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.sample_project.id
  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.sample_igw.id
  }
  tags = {
    "Name" = "public_route"
  }
}

#create route table for private subnet 
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.sample_project.id
  route {
    cidr_block = local.anywhere
    gateway_id = aws_nat_gateway.sample_ngw.id
  }
  tags = {
    "Name" = "public_route"
  }
}

#associate public subnets to route table
resource "aws_route_table_association" "public_subnet_associate" {
  count          = var.PublicSubnetCount
  subnet_id      = aws_subnet.public_vpc_subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

#associate private subnets to rute table 
resource "aws_route_table_association" "private_subnet_associate" {
  count          = var.PrivateSubnetCount
  subnet_id      = aws_subnet.private_vpc_subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}
