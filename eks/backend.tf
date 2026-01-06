terraform {
  required_version = " ~> 1.9.3"
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.49.0"
    }
  }
 
  backend "s3" {
    bucket = "akash-hola-tf-bucket"
    key    = "eks.terraform.tfstate"
    region = "us-east-1"
    dynamodynamodb_table = "Lock-files"
    encrypt=true
  }
}
  provider "aws" {
  region = var.aws-region
}
