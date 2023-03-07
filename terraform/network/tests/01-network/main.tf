module "network" {
  source = "../../aws/"

  vpc_cidr = "10.0.0.0/16"
  vpc_tags = {
    terraform = "true"
  }
}
