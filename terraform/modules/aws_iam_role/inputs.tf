variable "iam_role_assume_role_policy" {
  description = "Policy that grants an entity permission to assume the role"
  type        = string
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = "This IAM role is created with TF"
}

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it"
  type        = bool
  default     = false
}

variable "iam_role_policy_inline_policy_name" {
  description = "Name of the role policy"
  type        = string
  default     = null
}

variable "iam_role_policy_inline_policy_policy" {
  description = "Policy document as a JSON formatted string"
  type        = string
  default     = null
}

variable "iam_role_managed_policy_arns" {
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role"
  type        = number
  default     = 3600
}

variable "iam_role_name" {
  description = "Friendly name of the role"
  type        = string
  default     = "iam-role-created-with-tf"
}

variable "iam_role_name_prefix" {
  description = "Creates a unique friendly name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "iam_role_path" {
  description = "Path to the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null
}

variable "iam_role_policy_name" {
  description = "The name of the policy"
  type        = string
  default     = "IAM role policy created with TF"
}

variable "iam_role_policy_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "iam_role_policy_policy" {
  description = "The inline policy document"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "Key-value mapping of tags for the IAM role"
  type        = map(any)
  default = {
    tf_managed = "true"
  }
}
