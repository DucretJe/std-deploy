locals {
  eks_cluster_name = "eks-test"
}

resource "random_id" "id" {
  byte_length = 8
}

module "network" {
  source = "../../../../network/aws/"

  create_private_subnet = true
  create_public_subnet  = true

  sg_description = "Private security group for the VPC"
  sg_egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  sg_ingress_rules = []
  sg_name          = "priv-sg"

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }

  subnet_map_public_ip_on_launch = true

  vpc_cidr          = "10.0.0.0/16"
  vpc_dns_hostnames = true
  vpc_logs_name     = "vpc-logs-priv-${random_id.id.hex}"
}

output "eks_cluster_name" {
  value = local.eks_cluster_name
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
