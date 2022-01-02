output "vpc" {
  value = module.vpc.vpc_id
}

output "public_subnet" {
  value = module.vpc.public_subnets
}

output "private_subnet" {
  value = module.vpc.private_subnets
}

output "vpc_cidr" {
  value = "module.vpc.cidr"
}

output "db_subnets" {
  value = module.vpc.database_subnets
}