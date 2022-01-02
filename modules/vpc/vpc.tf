module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"
  name = var.name
  cidr = var.cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  

# Enable NAT GW  
  enable_nat_gateway = true
    single_nat_gateway  = true


# Create subnet groups for Database
  database_subnets = var.database_subnets
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true

# Enable DNS 
  enable_dns_hostnames = true
  enable_dns_support   = true

# Tags for subnets
# Tags for subnets
public_subnet_tags = {
    Name = "Public Subnets"
  }
  private_subnet_tags = {
    Name = "Private Subnets"
  }  
  database_subnet_tags = {
    Name = "Database Subnets"
  }
  tags = {
    Name = "demo-vpc"
    Environment = "dev"
  }
}