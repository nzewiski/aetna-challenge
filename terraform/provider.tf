provider "aws" {
  region = us-east-1

  assume_role {
    session_name = "terraform"
    role_arn     = "arn:aws:iam::672499893721:role/svc_terraform"
  }
}

terraform {
  backend "s3" {
    bucket = "tfstate-672499893721"
    key    = "aetna-challenge"
    region = "us-east-1"
  }
}