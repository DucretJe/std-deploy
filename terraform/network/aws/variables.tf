variable "create_public_subnet" {
  description = "Whether to create Public Subnets"
  type        = bool
  default     = true
}

variable "create_private_subnet" {
  description = "Whether to create Private Subnets"
  type        = bool
  default     = false
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

variable "subnet_map_public_ip_on_launch" {
  description = "A boolean flag to enable/disable public IP on launch for the subnets"
  type        = bool
  default     = false
}

variable "subnet_tags" {
  description = "A map of tags to assign to the subnets"
  type        = map(string)
  default     = {}
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

variable "vpc_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "vpc_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_logs_name" {
  description = "The name of the VPC logs"
  type        = string
  default     = "vpc-logs"
}
