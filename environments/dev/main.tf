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
    key    = "terraform/dev.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

# 🔹 Lookup the shared SG (already created once in shared-sg project)
data "aws_security_group" "shared_sg" {
  filter {
    name   = "group-name"
    values = ["shared-ec2-sg"]
  }
  vpc_id = var.vpc_id
}

# 🔹 EC2 instance in dev using shared SG
module "ec2" {
  source             = "../../modules/ec2"
  name               = "dev-ec2"
  ami                = var.ami
  instance_type      = var.instance_type
  subnet_id          = var.subnet_id
  key_name           = var.key_name
  security_group_ids = [data.aws_security_group.shared_sg.id]
}
