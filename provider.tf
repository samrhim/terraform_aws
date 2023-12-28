terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "us-west-2"
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
  profile                  = "vscode"
}