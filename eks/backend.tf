terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws={
      source = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }
  backend "s3" {
    bucket = "dev-akash-tf-bucket"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
    dynamodb_table = "Lock-Files"
    encrypt = true
  }
}
provider "aws" {
  region = var.aws_region
  
}