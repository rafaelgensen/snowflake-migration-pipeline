terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "dp-terraform-state" 
    key    = "dp/dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Terraform state bucket (auto provisionado)
resource "aws_s3_bucket" "tf_state" {
  bucket = "dp-terraform-state"

  tags = {
    Name    = "Terraform State Bucket"
    Project = var.project_prefix
    Env     = var.environment
  }
}