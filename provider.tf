terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}

provider "aws" {
  # Configuration options
  # tthis is change
  region = "ap-south-2"
}