variable "default_security_group_tags" {
  description = "Tags to apply on the default security group"
  type        = map(any)
  default = {
    tf_managed = "true"
  }
}

variable "vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "vpc_enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = false
}

variable "vpc_enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = false
}

variable "vpc_ipam_description" {
  description = "Description of the VPC IPAM"
  type        = string
  default     = "VPC IPAM created with Terraform"
}

variable "vpc_ipam_tags" {
  description = "Tags to apply on the VPC IPAM"
  type        = map(any)
  default = {
    tf_managed = "true"
  }
}

variable "vpc_ipam_pool_allocation_default_netmask_length" {
  description = "A default netmask length for allocations added to this VPC IPAM pool"
  type        = string
  default     = "16"
}

variable "vpc_ipam_pool_allocation_max_netmask_length" {
  description = "The maximum netmask length that will be required for CIDR allocations in this VPC IPAM pool"
  type        = string
  default     = "16"
}

variable "vpc_ipam_pool_allocation_min_netmask_length" {
  description = "The minimum netmask length that will be required for CIDR allocations in this VPC IPAM pool"
  type        = string
  default     = "16"
}

variable "vpc_ipam_pool_cidr_cidr" {
  description = "Provisions this CIDR from an IPAM address pool."
  type        = string
  default     = "172.16.0.0/16"
}

variable "vpc_ipam_pool_description" {
  description = "Description of the VPC IPAM pool"
  type        = string
  default     = "VPC IPAM pool created with Terraform"
}

variable "vpc_ipam_pool_tags" {
  description = "Tags to apply on the VPC IPAM pool"
  type        = map(any)
  default = {
    tf_managed = "true"
  }
}

variable "vpc_ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC"
  type        = number
  default     = 16
}

variable "vpc_tags" {
  description = "Tags to apply on the VPC"
  type        = map(any)
  default = {
    tf_managed = "true",
    Name       = "VPC created with Terraform"
  }
}
