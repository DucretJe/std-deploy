variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "eks_cluster_subnets_ids" {
  description = "The IDs of the subnets to use for the EKS cluster"
  type        = list(string)
}

variable "eks_group_nodes_tags" {
  description = "A map of tags to assign to the EKS workers"
  type        = map(string)
  default     = {}
}

variable "eks_worker_capacity_type" {
  description = "The capacity type to use for the EKS workers"
  type        = string
  default     = "SPOT"
}

variable "eks_workers_desired_capacity" {
  description = "The desired number of workers to use for the EKS cluster"
  type        = number
  default     = 1
}

variable "eks_workers_sg_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
  validation {
    condition     = length(var.eks_workers_sg_egress_rules) <= 50
    error_message = "The maximum number of egress rules per security group is 50."
  }
}

variable "eks_workers_sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
  validation {
    condition     = length(var.eks_workers_sg_ingress_rules) <= 50
    error_message = "The maximum number of ingress rules per security group is 50."
  }
}

variable "eks_workers_max_capacity" {
  description = "The maximum number of workers to use for the EKS cluster"
  type        = number
  default     = 2
}

variable "eks_workers_max_unavailable" {
  description = "The maximum number of workers to be unavailable for the EKS cluster"
  type        = number
  default     = 1
}

variable "eks_workers_min_capacity" {
  description = "The minimum number of workers to use for the EKS cluster"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
