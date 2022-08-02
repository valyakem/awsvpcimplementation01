#create a vpc
resource "aws_vpc" "vpc" {
  cidr_block                        = var.vpc_cidr
  instance_tenancy                  = "default"
  enable_dns_hostnames              = true

  tags  = {
    Name      = "${var.project_name}-vpc"
  } 
}

#Create an internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id                            = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}       

#get list of all availability zones
data "aws_availability_zones" "availability_zones" {}

resource "aws_subnet" "public_subnet_az1" {
    vpc_id                          = aws_vpc.vpc.id
    cidr_block                      = var.public_subnet_az1_cidr
    availability_zone               = data.aws_availability_zones.availability_zones.names[0]
    map_public_ip_on_launch     = true

    tags = {
      Name = "${var.project_name}-public_subnet"
    }
}

#create public subnet2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                            = aws_vpc.vpc.id
  cidr_block                        = var.public_subnet_az2_cidr
  availability_zone                 = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch           = true

  tags = {
    Name = "${var.project_name}-public_subnet_az2"
  } 
}

#create route table and add public routes
resource "aws_route_table" "public_route_table" {
  vpc_id                            = aws_vpc.vpc.id

  route {
    cidr_block          = "0.0.0.0/0"
    gateway_id          = aws_internet_gateway.internet_gateway.id
  } 

  tags = {
    Name = "public-route-table"
  }
}

#associate public subnet1 to "public route table"
resource "aws_route_table_association" "public_subnet1_az1_route_table_association" {
  subnet_id                             = aws_subnet.public_subnet_az1.id
  route_table_id                        = aws_route_table.public_route_table.id
}

#associate public subnet2 to "public route table"
resource "aws_route_table_association" "public_subnet2_az2_route_table_association" {
  subnet_id                             = aws_subnet.public_subnet_az2.id
  route_table_id                        = aws_route_table.public_route_table.id
}

#create private app subnet az1
resource "aws_subnet" "private_app_subent_az1" {
  vpc_id                                = aws_vpc.vpc.id
  cidr_block                            = var.private_app_subnet_az1_cidr
  availability_zone                     = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch               =  false

  tags = {
    Name  = "Private-app-subnet-az1"
  }
 }

 #create private app subnet az2
resource "aws_subnet" "private_app_subent_az2" {
  vpc_id                                = aws_vpc.vpc.id
  cidr_block                            = var.private_app_subnet_az2_cidr
  availability_zone                     = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch               = false

  tags = {
    Name  = "Private-app-subnet-az2"
  }
 }


#create private data subnet az1
resource "aws_subnet" "private_data_subent_az1" {
  vpc_id                                = aws_vpc.vpc.id
  cidr_block                            = var.private_data_subnet_az1_cidr
  availability_zone                     = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch               = false

  tags = {
    Name  = "Private-app-subnet-az1"
  }
 }

#create private data subnet az2
resource "aws_subnet" "private_data_subent_az2" {
  vpc_id                                = aws_vpc.vpc.id
  cidr_block                            = var.private_data_subnet_az2_cidr
  availability_zone                     = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch               = false

  tags = {
    Name  = "Private-app-subnet-az2"
  }
 }

