variable "cloudwatch_log_group_name" {
  description = "The name of the log group"
  type        = string
  default     = "cloudwatch-created-by-tf"
}

variable "cloudwatch_log_group_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_day" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_tags" {
  description = "Tags to apply on the Cloudwatch log group"
  type        = map(any)
  default = {
    tf_managed = "true"
  }
}
