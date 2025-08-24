terraform {
  required_version = "~> 1.9.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }
  backend "s3" {
    bucket         = "akash-eks-tfstate"     # your new bucket
    region         = "us-east-1"
    key            = "eks/terraform.tfstate"
    dynamodb_table = "eks-lock-table"        # your new DynamoDB table
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
