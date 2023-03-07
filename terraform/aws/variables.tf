variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {
    terraform = "true"
  }
}
