variable "ami_filters" {
  description = "value of the filter to apply to the AMI search."
  type        = map(list(string))
  default = {
    name = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

variable "ami_owner" {
  description = "The owner of the AMI to use. If not specified, the default is the owner alias amazon."
  type        = string
  default     = ""
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the autoscaling group."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group."
  type        = number
  default     = 1
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group."
  type        = number
  default     = 1
}

variable "asg_tags" {
  description = "The tags to use for the ASG."
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "asg_vpc_zone_identifier" {
  description = "The vpc zone identifier to use for the autoscaling group."
  type        = list(string)
}

variable "instance_interruption_behavior" {
  description = "The spot instance interruption behaviour to use for the launch template."
  type        = string
  default     = "terminate"
}

variable "launch_template_block_device_mappings_device_name" {
  description = "The device name to use for the launch template."
  type        = string
  default     = "/dev/xvda"
}

variable "launch_template_block_device_mappings_ebs_volume_size" {
  description = "The volume size to use for the launch template."
  type        = number
  default     = 8
}

variable "launch_template_instance_type" {
  description = "The instance type to use for the launch template."
  type        = string
  default     = "t2.micro"
}

variable "launch_template_name_prefix" {
  description = "The name prefix to use for the launch template."
  type        = string
  default     = "ltmplt"
}

variable "launch_template_network_interfaces_associate_public_ip_address" {
  description = "Associate a public ip address with the network interface."
  type        = bool
  default     = false
}

variable "launch_template_tags" {
  description = "The tags to use for the launch template."
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "launch_template_vpc_security_group_ids" {
  description = "The security group ids to use for the launch template."
  type        = list(string)
}

variable "lb_name" {
  description = "The name to use for the load balancer."
  type        = string
  default     = "lb"
}

variable "lb_internal" {
  description = "Whether the load balancer is internal."
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "The type to use for the load balancer."
  type        = string
  default     = "application"
}

variable "lb_tags" {
  description = "The tags to use for the load balancer."
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "lb_tg_prefix_name" {
  description = "The prefix name to use for the load balancer."
  type        = string
  default     = "lb"
}

variable "lb_tg_port" {
  description = "The port to use for the load balancer."
  type        = number
  default     = 80
}

variable "lb_tg_protocol" {
  description = "The protocol to use for the load balancer."
  type        = string
  default     = "HTTP"
}

variable "lb_tg_health_check_path" {
  description = "The path to use for the load balancer health check."
  type        = string
  default     = "/"
}

variable "lb_tg_health_check_protocol" {
  description = "The protocol to use for the load balancer health check."
  type        = string
  default     = "HTTP"
}

variable "on_demand_allocation_strategy" {
  description = "The on demand allocation strategy to use for the launch template."
  type        = string
  default     = "prioritized"
}

variable "on_demand_base_capacity" {
  description = "The on demand base capacity to use for the launch template."
  type        = number
  default     = 0
}

variable "security_groups" {
  description = "The security groups to use for the launch template."
  type        = list(string)
  default     = []
}

variable "ssh_keys" {
  description = "The ssh keys to use for the launch template."
  type        = list(string)
  default     = []
}

variable "spot_allocation_strategy" {
  description = "The spot allocation strategy to use for the launch template."
  type        = string
  default     = "lowest-price"
}

variable "spot_instance_pools" {
  description = "The spot instance pools to use for the launch template."
  type        = number
  default     = 2
}

variable "spot_instance_type" {
  description = "The spot instance type to use for the launch template."
  type        = string
  default     = "one-time"
}

variable "spot_block_duration_minutes" {
  description = "The spot block duration in minutes to use for the launch template."
  type        = number
  default     = 0
}

variable "spot_max_price" {
  description = "The spot max price to use for the launch template."
  type        = string
  default     = "0.1"
}

variable "use_spot_instances" {
  description = "Whether to use spot instances or not."
  type        = bool
  default     = false
}

variable "subnets" {
  description = "List of the available subnets."
  type        = list(string)
}

variable "vpc_id" {
  description = "The vpc id to use for the launch template."
  type        = string
}
