  module "public-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"
  
  name = "bastion-sg"
  vpc_id = var.vpc

  # Ingress Rules 
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Egress Rules
  egress_rules = ["all-all"]
}

# Security for private servers

  module "private-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"
  
  name = "private-sg"
  vpc_id = var.vpc
  
  # Ingress Rules 
  ingress_rules = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Egress Rules
  egress_rules = ["all-all"]
}

module "loadbalancer-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"
  
  name = "loadbalancer-sg"
  vpc_id = var.vpc

  # Ingress Rules 
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Egress Rules
  egress_rules = ["all-all"]
}