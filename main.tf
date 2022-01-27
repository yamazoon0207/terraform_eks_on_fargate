provider "aws" {
  region = "us-west-2"
}

terraform {
  required_version = "= 1.1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73.0"
    }
  }
}
