provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment = "Test"
      Service     = "ArgoCD"
      Application = "CI - Validation"
      Terraform   = "true"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
