variable "vpc" {}

variable "cidr" {}

variable "public_subnets" {}
variable "private_subnets" {}


variable "sg_private" {}

variable "sg_public" {}


variable "ami" {
  type = string
  default = "ami-052cef05d01020f1d"
}

variable "instance_type" {
  type = string
  default = "t2.small"
}

variable "private_instance_count" {
  type = string
  default = "2"
}
