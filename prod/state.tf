terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29" #"3.72.0"#"3.37.0"

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
  #assume_role {
  #  role_arn = "arn:aws:iam::602837221957:role/Cross-Account-Ops-Role" #"arn:aws:iam::005851909592:role/pord-ops-terraform" #format("arn:aws:iam::%s:role/TerraformRole", var.account_id)
  #}
}

provider "aws" {
  alias      = "ops"
  region     = "us-east-1"
  access_key = var.ops_aws_access_key
  secret_key = var.ops_aws_secret_key

}