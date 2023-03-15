variable "ami_filters" {
  description = "value of the filter to apply to the AMI search."
  type        = map(list(string))
  default = {
    name = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  validation {
    condition     = length(var.ami_filters) > 0
    error_message = "The ami_filters map must contain at least one filter."
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
  validation {
    condition     = var.asg_desired_capacity >= 0
    error_message = "The desired capacity must be greater than or equal to 0."
  }
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group."
  type        = number
  default     = 1
  validation {
    condition     = var.asg_max_size >= 1
    error_message = "The maximum size of the autoscaling group must be greater than or equal to 1."
  }
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group."
  type        = number
  default     = 1
  validation {
    condition     = var.asg_min_size >= 0
    error_message = "The minimum size must be greater than or equal to 0."
  }
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
  validation {
    condition     = length(var.asg_vpc_zone_identifier) > 0
    error_message = "The vpc_zone_identifier list must contain at least one value."
  }
}


variable "launch_template_block_device_mappings_device_name" {
  description = "The device name to use for the launch template."
  type        = string
  default     = "/dev/xvda"
  validation {
    condition     = length(var.launch_template_block_device_mappings_device_name) > 0
    error_message = "The device name must not be empty."
  }
}

variable "launch_template_block_device_mappings_ebs_volume_size" {
  description = "The volume size to use for the launch template."
  type        = number
  default     = 8
  validation {
    condition     = var.launch_template_block_device_mappings_ebs_volume_size > 0
    error_message = "The volume size must be greater than 0."
  }
}

variable "launch_template_instance_type" {
  description = "The instance type to use for the launch template."
  type        = string
  default     = "t2.micro"
  validation {
    condition     = length(var.launch_template_instance_type) > 0
    error_message = "The instance type must not be empty."
  }
}

variable "launch_template_name_prefix" {
  description = "The name prefix to use for the launch template."
  type        = string
  default     = "ltmplt"
  validation {
    condition     = length(var.launch_template_name_prefix) > 0
    error_message = "The name prefix must not be empty."
  }
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

variable "lb_internal" {
  description = "Whether the load balancer is internal."
  type        = bool
  default     = false
}

variable "lb_name" {
  description = "The name to use for the load balancer."
  type        = string
  default     = "lb"
  validation {
    condition     = length(var.lb_name) > 0
    error_message = "The load balancer name must not be empty."
  }
}

variable "lb_tags" {
  description = "The tags to use for the load balancer."
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "lb_tg_health_check_path" {
  description = "The path to use for the load balancer health check."
  type        = string
  default     = "/"
  validation {
    condition     = length(var.lb_tg_health_check_path) > 0
    error_message = "The health check path must not be empty."
  }
}

variable "lb_tg_health_check_protocol" {
  description = "The protocol to use for the load balancer health check."
  type        = string
  default     = "HTTP"
  validation {
    condition     = length(var.lb_tg_health_check_protocol) > 0
    error_message = "The health check protocol must not be empty."
  }
}

variable "lb_tg_port" {
  description = "The port to use for the load balancer."
  type        = number
  default     = 80
  validation {
    condition     = var.lb_tg_port > 0 && var.lb_tg_port <= 65535
    error_message = "The port must be between 1 and 65535."
  }
}

variable "lb_tg_prefix_name" {
  description = "The prefix name to use for the load balancer."
  type        = string
  default     = "lb"
  validation {
    condition     = length(var.lb_tg_prefix_name) > 0
    error_message = "The prefix name must not be empty."
  }
}

variable "lb_tg_protocol" {
  description = "The protocol to use for the load balancer."
  type        = string
  default     = "HTTP"
  validation {
    condition     = length(var.lb_tg_protocol) > 0
    error_message = "The protocol must not be empty."
  }
}

variable "lb_type" {
  description = "The type to use for the load balancer."
  type        = string
  default     = "application"
  validation {
    condition     = length(var.lb_type) > 0
    error_message = "The load balancer type must not be empty."
  }
}

variable "on_demand_allocation_strategy" {
  description = "The on demand allocation strategy to use for the launch template."
  type        = string
  default     = "prioritized"
  validation {
    condition     = length(var.on_demand_allocation_strategy) > 0
    error_message = "The on demand allocation strategy must not be empty."
  }
}

variable "on_demand_base_capacity" {
  description = "The on demand base capacity to use for the launch template."
  type        = number
  default     = 0
  validation {
    condition     = var.on_demand_base_capacity >= 0
    error_message = "The on demand base capacity must be greater than or equal to 0."
  }
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
  validation {
    condition     = length(var.spot_allocation_strategy) > 0
    error_message = "The spot allocation strategy must not be empty."
  }
}

variable "spot_instance_pools" {
  description = "The spot instance pools to use for the launch template."
  type        = number
  default     = 2
  validation {
    condition     = var.spot_instance_pools > 0
    error_message = "The spot instance pools must be greater than 0."
  }
}

variable "spot_max_price" {
  description = "The spot max price to use for the launch template."
  type        = string
  default     = "0.1"
  validation {
    condition     = length(var.spot_max_price) > 0
    error_message = "The spot max price must not be empty."
  }
}

variable "subnets" {
  description = "List of the available subnets."
  type        = list(string)
  validation {
    condition     = length(var.subnets) > 0
    error_message = "The subnets list must contain at least one value."
  }
}

variable "vpc_id" {
  description = "The vpc id to use for the launch template."
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "The VPC ID must not be empty."
  }
}
