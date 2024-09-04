#vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-ansible-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name        = "terraform-ansible-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "terraform-ansible-subnet"
  }

}

#SG

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "terraform-ansible-sg"
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "terraform-ansible-sg"
  }


}

#EC2\

module "ec2_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["instance1", "instance2", "instance3"])
  name     = "tetris-${each.key}"

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = "ansible"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "tetris-${each.key}"
    Terraform   = "true"
    Environment = "dev"
  }
}

