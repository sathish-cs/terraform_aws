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

#############

# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name = "demo-alb"
  load_balancer_type = "application"
  vpc_id = var.vpc
  subnets = var.alb_subnets
  security_groups = [module.loadbalancer-sg.security_group_id]
  # Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0 # App1 TG associated to this listener
    }
  ]  
  # Target Groups
  target_groups = [
    # App1 Target Group - TG Index = 0
    {
      name_prefix          = "app1-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # App1 Target Group - Targets
      targets = {
        webserver1 = {
          target_id = module.ec2_private.id[0]
          port      = 80
        },
        webserver2 = {
          target_id = module.ec2_private.id[1]
          port      = 80
        }
      }
    }  
  ]
}