locals {
  zones_count = length(var.subnets)
}

data "aws_ami" "this" {
  most_recent = true

  dynamic "filter" {
    for_each = var.ami_filters

    content {
      name   = filter.key
      values = filter.value
    }
  }

  owners = var.ami_owner != "" ? [var.ami_owner] : null
}

resource "aws_launch_template" "this" {
  name_prefix = var.launch_template_name_prefix

  block_device_mappings {
    device_name = var.launch_template_block_device_mappings_device_name

    ebs {
      volume_size = var.launch_template_block_device_mappings_ebs_volume_size
    }
  }
  network_interfaces {
    delete_on_termination       = true
    associate_public_ip_address = var.launch_template_network_interfaces_associate_public_ip_address
    security_groups             = var.security_groups
  }
  image_id      = data.aws_ami.this.id
  instance_type = var.launch_template_instance_type

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"

    tags = var.launch_template_tags
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  vpc_zone_identifier = var.asg_vpc_zone_identifier

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
    }
    instances_distribution {
      on_demand_allocation_strategy = var.on_demand_allocation_strategy
      on_demand_base_capacity       = var.on_demand_base_capacity
      spot_allocation_strategy      = var.spot_allocation_strategy
      spot_instance_pools           = var.spot_instance_pools
      spot_max_price                = var.spot_max_price
    }
  }

  target_group_arns = [aws_lb_target_group.this.arn]

  tags = [
    for key, value in var.asg_tags :
    {
      key   = key
      value = value
    }
  ]
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    ssh_keys = join("\n", var.ssh_keys)
  }
}
