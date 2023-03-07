terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "jducret"

    workspaces {
      name = "std-deploy"
    }
  }
}
