resource "random_id" "id" {
  byte_length = 8
}

module "network" {
  source = "../../../../network/aws/"

  sg_description = "Security group for the VPC"
  sg_egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  sg_ingress_rules = [
    {
      description = "Allow HTTPS inbound traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow SSH inbound traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  sg_name = "sg"

  vpc_cidr      = "10.0.0.0/16"
  vpc_logs_name = "vpc-logs-${random_id.id.hex}"
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "sg_id" {
  value = module.network.sg_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}
