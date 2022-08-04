variable "kms_key_description" {
  description = "The description of the key as viewed in AWS console"
  type = sting
  default = "KMS Key created with Terraform"
}

variable "kms_key_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key"
  type = int
  default = 7
}

variable "kms_key_customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports"
  type = string
  default = "SYMMETRIC_DEFAULT"
}

variable "kms_key_key_usage" {
  description = "Specifies the intended use of the key"
  type = string
  default = "ENCRYPT_DECRYPT"
}

variable "kms_key_policy" {
  description = "A valid policy JSON document"
  type = string
}

variable "kms_key_bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the key policy lockout safety check"
  type = bool
  default = false
}

variable "kms_key_is_enabled" {
  description = "Specifies whether the key is enabled"
  type = bool
  default = true
}

variable "kms_key_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type = bool
  default = false
}

variable "kms_key_multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key"
  type = bool
  default = false
}

variable "kms_key_tags" {
  description = "Key-value mapping of tags for the IAM role"
  type        = map(any)
  default = {
    tf_managed = "true"
  }
}
