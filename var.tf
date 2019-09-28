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
variable "ami_id" {
description = "AMI ID"
default = "ami-0cb0e70f44e1a4bb5"
}
variable instance_type {
description = "Instance to be launched"
default = "t2.micro"
}
