terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.37.0"

    }
  }
  backend "http" {
  }
}

provider "aws" {
  #shared_credentials_file = "~/.aws/credentials"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}