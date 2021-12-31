module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  vpc = module.vpc.vpc
  cidr = module.vpc.vpc_cidr
  public_subnets = module.vpc.public_subnet[0]
  private_subnets = module.vpc.private_subnet
  sg_private =  ""
  sg_public = ""
}