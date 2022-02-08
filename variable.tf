variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "cidr block for the vpc"
}
variable "pub_cidr" {
  default     = "10.0.1.0/24"
  description = "cidr block for the public subnet"
}
variable "prv_cidr" {
  default     = "10.0.2.0/24"
  description = "cidr block for the private subnet"
}
variable "az_1" {
  default     = "eu-west-2a"
  description = "availability zone to be used for public subnet"
}
variable "az_2" {
  default     = "eu-west-2c"
  description = "availability zone to be used for private subnet"
}
variable "port_http" {
  default     = "80"
  description = "allow port 80 for http"
}
variable "all_cidr" {
  default     = "0.0.0.0/0"
  description = "cidr block range"
}
variable "my_cidr" {
  default     = "78.152.219.17/32"
  description = "my ipaddress to allow traffic from"
}
variable "instance_tpye" {
  default     = "t2.micro"
  description = "the instance type to be used for the VMs"
}
variable "ami" {
  default     = "ami-0015a39e4b7c0966f"
  description = "the ami to be used for the VMs"
}
