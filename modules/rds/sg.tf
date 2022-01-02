  module "db-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"
  
  name = "db-sg"
  vpc_id = var.vpc
  
  # Ingress Rules 
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = "0.0.0.0/0" # need to change this to application cidr block.
    },
  ]

  # Egress Rules
  egress_rules = ["all-all"]
}