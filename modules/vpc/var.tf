variable "name" {
    type = string
    default = "demo"
}
variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}  
  
variable "azs" {
    type = list(any)
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]  
}

variable "private_subnets" {
    type = list(any)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
} 
  
variable "public_subnets" {
    type = list(any) 
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database_subnets" {
    type = list(any) 
    default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}
