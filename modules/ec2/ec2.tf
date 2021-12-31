# Create bastion in public subnet
module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  depends_on = [ var.vpc ]
  name                   = "bastion"
  ami                    = var.ami
  key_name = aws_key_pair.key.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.public-sg.security_group_id]
  subnet_id = var.public_subnets
}

# Create EIP for bastion server

resource "aws_eip" "bastion_eip" {
  depends_on = [ var.vpc ]
  instance = module.ec2_bastion.id[0]
  vpc      = true
}

# Create app instances in private subnets

module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  depends_on = [ var.vpc ]
  name                   = "webservers"
  ami                    = var.ami
  key_name = aws_key_pair.key.key_name
  instance_type          = var.instance_type
  instance_count         = var.private_instance_count
  vpc_security_group_ids = [module.private-sg.security_group_id]
  subnet_ids = var.private_subnets
  user_data = file("${path.module}/webserver.sh")
}

resource "aws_key_pair" "key" {
  key_name   = "ssh-key"
  public_key = tls_private_key.ssh-key.public_key_openssh
}


resource "local_file" "pem_file" {
  filename             = "${path.module}/mykey.pem" 
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.ssh-key.private_key_pem
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}