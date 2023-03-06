terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.58.0"
    }

  }
  backend "s3" {
    bucket = "leumi-bucket"
    region = "eu-central-1"
    key    = "terraform.tfstate"
  }
}