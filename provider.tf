terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.46.0"
    }
  }

  required_version = ">= 0.15.5" # Terraform version should be greater than or equal to this
}

provider "aws" {
  region  = "ap-south-1"
}