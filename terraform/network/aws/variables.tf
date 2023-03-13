variable "internet_gateway" {
  description = "Whether to create an Internet Gateway for the VPC"
  type        = bool
  default     = true
  validation {
    condition     = length(var.internet_gateway) <= 1
    error_message = "The Internet Gateway can have a maximum of 1 character."
  }
}

variable "internet_gateway_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    terraform = "true"
  }
  validation {
    condition     = length(keys(var.internet_gateway_tags)) <= 10
    error_message = "The maximum number of tags that can be applied to a resource is 10."
  }
}

variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "Security group for the VPC"
  validation {
    condition     = length(var.sg_description) <= 255
    error_message = "The description can have a maximum of 255 characters."
  }
}

variable "sg_egress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  validation {
    condition     = length(var.sg_egress_rules) <= 50
    error_message = "The maximum number of egress rules per security group is 50."
  }
}

variable "sg_ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  validation {
    condition     = length(var.sg_ingress_rules) <= 50
    error_message = "The maximum number of ingress rules per security group is 50."
  }
}

variable "sg_name" {
  description = "The name of the security group"
  type        = string
  default     = "sg"
  validation {
    condition     = length(var.sg_name) <= 255
    error_message = "The name can have a maximum of 255 characters."
  }
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = length(var.vpc_cidr) <= 32
    error_message = "The CIDR block can have a maximum of 32 characters."
  }
}

variable "vpc_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    terraform = "true"
  }
  validation {
    condition     = length(keys(var.vpc_tags)) <= 10
    error_message = "The maximum number of tags that can be applied to a resource is 10."
  }
}
