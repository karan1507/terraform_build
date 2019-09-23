variable "region" {
  default = "ap-south-1"
}
variable "vpc_poc" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR and acceptable by AWS and can be overridden also"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public-subnet-1" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.0.0.0/28"
}
variable "public-subnet-2" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.0.0.16/28"
}
variable "private-subnet-1" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.0.0.32/28"
}
variable "private-subnet-2" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.0.0.48/28"
}



[root@ip-10-0-0-10 terraform]# ^C
[root@ip-10-0-0-10 terraform]# ls
main.tf  terraform.tfstate  terraform.tfstate.backup  var.tf
[root@ip-10-0-0-10 terraform]# cat main.tf
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

resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"
  tags = {
    Name = "Production-EIP"
  }
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.elastic-ip-for-nat-gw.id}"
  subnet_id     = "${aws_subnet.public-subnet-1.id}"
  tags = {
    Name = "Production-NAT-GW"
  }
  depends_on = ["aws_eip.elastic-ip-for-nat-gw"]
}
resource "aws_route" "nat-gw-route" {
  route_table_id         = "${aws_route_table.private-route-table.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat-gw.id}"
  destination_cidr_block = "0.0.0.0/0"
}
