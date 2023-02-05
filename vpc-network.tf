terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

// CONFIGURATION SETTINGS
provider "aws" {
  profile                  = "my_prof"
  shared_config_files      = ["/home/vagrant/.aws/config"]
  shared_credentials_files = ["/home/vagrant/.aws/credentials"]
  region                   = "us-east-1"
}

// SETTING UP THE VPC
resource "aws_vpc" "hmw-vpc" {
  cidr_block            = "10.0.0.0/16"
  instance_tenancy      = "default"
  enable_dns_support    = "true"
  enable_dns_hostnames  = "true"
  tags  = {
    Name = "homework-vpc"
  }
}

// CREATING INTERNET GATEWAY FOR THE INSTANCES
resource "aws_internet_gateway" "internet-gw" {
 vpc_id = aws_vpc.hmw-vpc.id
 tags   = {
   Name = "homework-gateway"
 }
}

// CREATING THE ROUTE TABLES FOR THE INTERNET GATEWAY
resource "aws_route_table" "route-table-gw" {
  vpc_id = aws_vpc.hmw-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  tags   = {
    Name = "homework-route-gateway"
  }
 }

// CREATING ROUTE TABLE ASSOCIATIONS FOR THE SUBNETS
resource "aws_route_table_association" "public-subnet-rta1" {
  subnet_id      = aws_subnet.hmw-public-subnets1.id
  route_table_id = aws_route_table.route-table-gw.id
}
resource "aws_route_table_association" "public-subnet-rta2" {
  subnet_id      = aws_subnet.hmw-public-subnets2.id
  route_table_id = aws_route_table.route-table-gw.id
}
resource "aws_route_table_association" "public-subnet-rta3" {
  subnet_id      = aws_subnet.hmw-public-subnets3.id
  route_table_id = aws_route_table.route-table-gw.id
}

// CREATING PUBLIC SUBNETS INSIDE VPC
resource "aws_subnet" "hmw-public-subnets1" {
  vpc_id                  = aws_vpc.hmw-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags                    = {
   Name                   = "homework-public-subnets"
  }
 }
resource "aws_subnet" "hmw-public-subnets2" {
  vpc_id                  = aws_vpc.hmw-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags                    = {
   Name                   = "homework-public-subnets"
  }
}
resource "aws_subnet" "hmw-public-subnets3" {
  vpc_id                  = aws_vpc.hmw-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = "true"
  tags                    = {
   Name                   = "homework-public-subnets"
  }
 }








