variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "Security group for the VPC"
}

variable "sg_egress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "sg_ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "sg_name" {
  description = "The name of the security group"
  type        = string
  default     = "sg"
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {
    terraform = "true"
  }
}
