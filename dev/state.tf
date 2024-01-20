terraform {
  required_version = ">=1.0" #">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21" #"3.72.0"#"3.37.0"

    }
  }
  backend "http" {
  }
}

provider "aws" {
  # alias = "dev"
  #shared_credentials_file = "~/.aws/credentials"
  region     = "us-eaST-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  #assume_role {
  #  role_arn = "arn:aws:iam::005851909592:role/assume_role" #format("arn:aws:iam::%s:role/TerraformRole", var.account_id)
  #}
}

provider "aws" {
  alias      = "ops"
  region     = "us-eaST-1"
  access_key = var.ops_aws_access_key
  secret_key = var.ops_aws_secret_key
  #assume_role {
  #  role_arn = "arn:aws:iam::005851909592:role/Terraform-Ops-Role"#format("arn:aws:iam::%s:role/TerraformRole", var.account_id)
  #}
  #assume_role {
  #  role_arn = format("arn:aws:iam::%s:role/TerraformRole", var.remote_account_id)
  #}
}

data "aws_caller_identity" "source" {
  provider = aws #.source
}

data "aws_iam_policy" "ec2" {
  provider = aws.ops
  name     = "AdministratorAccess"
}

data "aws_iam_policy" "eks" {
  provider = aws.ops
  name     = "EKSFULLACCESS"
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws.ops
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
    }
  }
}
resource "aws_iam_role" "assume_role" {
  provider            = aws.ops
  name                = "assume_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [data.aws_iam_policy.ec2.arn, data.aws_iam_policy.eks.arn]
  tags                = {}
}