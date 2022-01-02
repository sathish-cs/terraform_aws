variable "db_identifier" {
    type = string
    default = "demo-db"
}

variable "vpc" {}

variable "cidr" {}

variable "db_name" {
    type = string
    default = "demo_db"
}
variable "db_username" {
    type = string
    default = "demo_user"
}
variable "db_password" {
    type = string
    default = "dnkas1ahc!s"
}


variable "db_subnets" {}