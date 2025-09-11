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
    key    = "workspace-demo/${terraform.workspace}/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

# -----------------------------
# IAM User Module
# -----------------------------
module "iam_user" {
  source    = "./modules/iam"
  user_name = var.user_name
}

# -----------------------------
# S3 Bucket Module
# -----------------------------
module "s3_bucket" {
  source = "./modules/s3"
  name   = "${var.s3_bucket_name}-${terraform.workspace}"
}

