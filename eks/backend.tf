terraform {
  required_version = ">= 1.9.3, < 2.0.0"
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.49.0"
    }
  }
 
  backend "s3" {
    bucket = "dev-akash-tf-bucket"
    key    = "eks.terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "Lock-files"
    encrypt=true
  }
}
  provider "aws" {
  region = var.aws_region
}
