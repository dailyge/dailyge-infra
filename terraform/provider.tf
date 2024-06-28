terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }

  backend "local" {}
}

provider "aws" {
  region = "ap-northeast-2"
}
