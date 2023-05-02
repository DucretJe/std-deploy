provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment = "Test"
      Service     = "Computing - EKS"
      Application = "CI - Validation"
      Terraform   = "true"
    }
  }
}
