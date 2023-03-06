variable "region" {
  default = "eu-central-1"
}
variable "vpc-name" {
  default = "Leumi-VPC"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "subnet_a" {
  default = "10.0.1.0/24"
}
variable "subnet_b" {
  default = "10.0.2.0/24"
}
variable "AZ_a" {
  default = "eu-central-1a"
}
variable "AZ_b" {
  default = "eu-central-1b"
}
variable "Leumi_cidr" {
  default = "91.231.246.50/32"
}