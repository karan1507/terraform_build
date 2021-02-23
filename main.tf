provider "aws" {
  region = "${var.region}"
}
resource "aws_vpc" "vpc_poc" {
    cidr_block = "${var.vpc_poc}"
    enable_dns_hostnames = true

tags = {
    Name = "POC VPC"
  }
}
resource "aws_subnet" "public-subnet-1" {
  cidr_block        = "${var.public-subnet-1}"
  vpc_id            = "${aws_vpc.vpc_poc.id}"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-subent-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  cidr_block        = "${var.public-subnet-2}"
  vpc_id            = "${aws_vpc.vpc_poc.id}"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-subent-2"
  }
}
resource "aws_subnet" "private-subnet-1" {
  cidr_block        = "${var.private-subnet-1}"
  vpc_id            = "${aws_vpc.vpc_poc.id}"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-subent-1"
  }
}
resource "aws_subnet" "private-subnet-2" {
  cidr_block        = "${var.private-subnet-2}"
  vpc_id            = "${aws_vpc.vpc_poc.id}"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-subent-2"
  }
}
resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.vpc_poc.id}"
  tags = {
    Name = "Public-Route-Table"
  }
}
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id      = "${aws_subnet.public-subnet-1.id}"
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id      = "${aws_subnet.public-subnet-2.id}"
}
resource "aws_route_table" "private-route-table" {
  vpc_id = "${aws_vpc.vpc_poc.id}"
  tags = {
    Name = "Private-Route-Table"
  }
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${aws_subnet.private-subnet-1.id}"
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${aws_subnet.private-subnet-2.id}"
}
resource "aws_internet_gateway" "production-igw" {
  vpc_id = "${aws_vpc.vpc_poc.id}"
  tags = {
    Name = "Production-IGW"
  }
}
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = "${aws_route_table.public-route-table.id}"
  gateway_id             = "${aws_internet_gateway.production-igw.id}"
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_instance" "web" {
  ami           = "ami-0cb0e70f44e1a4bb5"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  subnet_id = "${aws_subnet.public-subnet-1.id}"
  monitoring = "false"

  tags = {
    Name = "HelloWorld02232021-newbranch"
  }
}
