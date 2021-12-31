# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name = "demo-alb"
  load_balancer_type = "application"
  vpc_id = var.vpc
  subnets = var.public_subnets
  security_groups = [module.loadbalancer_sg.this_security_group_id]
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
        webserver = {
          target_id = var.ec2_id
          port      = 80
        },
        webserver = {
          target_id = var.ec2_id
          port      = 80
        }
      }
    }  
  ]
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