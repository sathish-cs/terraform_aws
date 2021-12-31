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

module "alb" {
  vpc = module.vpc.vpc
  ec2_id = module.ec2.webservers_id
  public_subnets = module.vpc.public_subnet
  private_subnets = module.vpc.private_subnet
  //lb_sg = module.ec2.lb_sg
  source = "./modules/alb"
}
