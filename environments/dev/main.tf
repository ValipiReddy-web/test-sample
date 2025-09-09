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

# Reference shared security group
data "aws_security_group" "shared_sg" {
  filter {
    name   = "group-name"
    values = ["shared-ec2-sg"]   # Name of your shared SG
  }
  vpc_id = var.vpc_id
}

module "ec2" {
  source            = "../../modules/ec2"
  name              = "${var.env}-ec2"
  ami               = var.ami
  subnet_id         = var.subnet_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_group_ids = [data.aws_security_group.shared_sg.id]
}
