module "cluster" {
  source = "../../aws/"

  eks_cluster_name                = data.terraform_remote_state.network.outputs.eks_cluster_name
  eks_cluster_public_subnets_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
  eks_cluster_private_subnets_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  eks_group_nodes_tags = {
    "kubernetes.io/cluster/${data.terraform_remote_state.network.outputs.eks_cluster_name}"     = "owned"
    "k8s.io/cluster-autoscaler/${data.terraform_remote_state.network.outputs.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                                                         = "true"
  }

  eks_private_access     = true
  eks_public_access      = true
  eks_public_access_cidr = ["${data.local_file.ip.content}/32"]

  externaldns_provider_settings = {
    provider     = "aws"
    txtOwnerId   = "Z07480952D5MIKMEVW96O"
    aws_zoneType = "public"
  }

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../01-network/terraform.tfstate"
  }
}

output "aws_eks_cluster_endpoint" {
  value = module.cluster.endpoint
}

output "aws_eks_cluster_kubeconfig_ca_data" {
  value     = module.cluster.aws_eks_cluster_kubeconfig_ca_data
  sensitive = true
}

output "name" {
  value = module.cluster.name
}

resource "null_resource" "get_runner_ip" {
  provisioner "local-exec" {
    command     = "curl -s https://ifconfig.me/ip > temp.txt"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      # Set the HTTP_PROXY and HTTPS_PROXY environment variables if you need to use a proxy to access the internet.
      # http_proxy = "http://proxy.example.com:8080"
      # https_proxy = "http://proxy.example.com:8080"
    }
  }
}

data "local_file" "ip" {
  depends_on = [null_resource.get_runner_ip]
  filename   = "${path.module}/temp.txt"
}
