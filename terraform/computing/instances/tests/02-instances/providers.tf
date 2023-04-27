terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

provider "http" {}
