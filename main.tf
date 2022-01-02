module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  vpc = module.vpc.vpc
  cidr = module.vpc.vpc_cidr
  public_subnets = module.vpc.public_subnet[0]
  alb_subnets = [module.vpc.public_subnet[0],module.vpc.public_subnet[1]]
  private_subnets = module.vpc.private_subnet
  sg_private =  ""
  sg_public = ""
}

module "rds" {
  source = "./modules/rds"
  cidr = module.vpc.vpc_cidr
  vpc = module.vpc.vpc
  db_subnets = module.vpc.db_subnets
  
}