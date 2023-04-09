provider "aws" {
  profile = "default"
  region  = "eu-central-1"

  default_tags {
    tags = {
      Environment = "Test"
      Service     = "Network"
      Application = "CI - Validation"
      Terraform   = "true"
    }
  }
}
