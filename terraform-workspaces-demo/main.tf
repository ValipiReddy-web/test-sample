terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "terraform-bucket-2025sep"
    key    = "terraform/dev.tfstate"  # Unique for dev
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

# -----------------------------
# Security Group Module
# -----------------------------
module "sg" {
  source      = "../../modules/security-grp"
  name        = "shared-ec2-sg"
  vpc_id      = var.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# -----------------------------
# EC2 Module
# -----------------------------
module "ec2" {
  source            = "../../modules/ec2"
  name              = "dev-ec2"
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  security_group_ids = [module.sg.security_group_id]
}
