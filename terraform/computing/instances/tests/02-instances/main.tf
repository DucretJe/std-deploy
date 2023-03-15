module "instances" {
  source = "../../aws/"

  ami_owner            = ""
  asg_desired_capacity = 1
  asg_max_size         = 1
  asg_min_size         = 1
  asg_tags = {
    terraform = "true"
    test      = "true"
  }
  asg_vpc_zone_identifier                                        = data.terraform_remote_state.network.outputs.subnet_ids
  launch_template_block_device_mappings_device_name              = "/dev/xvda"
  launch_template_block_device_mappings_ebs_volume_size          = 10
  launch_template_instance_type                                  = "t2.micro"
  launch_template_name_prefix                                    = "ltmplt"
  launch_template_network_interfaces_associate_public_ip_address = true
  security_groups = [
    data.terraform_remote_state.network.outputs.sg_id
  ]
  launch_template_tags = {
    terraform = "true"
    test      = "true"
    name      = "test"
  }
  launch_template_vpc_security_group_ids = [data.terraform_remote_state.network.outputs.sg_id]
  ami_filters = {
    name = ["bitnami-nginx-1.23.3-21-r20-linux-debian-11-x86_64-hvm-ebs-nami-*"]
  }
  use_spot_instances = true
  spot_max_price     = "0.004"
  ssh_keys           = [data.http.ssh_keys.body]
  subnets            = data.terraform_remote_state.network.outputs.subnet_ids
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
}

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../01-network/terraform.tfstate"
  }
}

output "aws_launch_template_id" {
  value = module.instances.aws_launch_template_id
}

output "aws_autoscaling_group_id" {
  value = module.instances.aws_autoscaling_group_id
}

output "aws_load_balancer_dns_name" {
  value = module.instances.aws_load_balancer_dns_name
}

data "http" "ssh_keys" {
  url = "https://github.com/ducretje.keys"
}
