terraform {
  required_version = ">= 1.9.3, < 2.0.0"
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.49.0"
    }
  }
 
  backend "s3" {
    bucket = "akash_hola_tf_bucket"
    key    = "eks.terraform.tfstate"
    region = "us_east_1"
    dynamodynamodb_table = "Lock_files"
    encrypt=true
  }
}
  provider "aws" {
  region = var.aws_region
}
