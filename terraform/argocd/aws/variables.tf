variable "cloudflare_api_token" {
  description = "The Cloudflare API token."
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "The Cloudflare account ID."
  type        = string
}

variable "cloudflare_zone" {
  description = "The Cloudflare zone."
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  type        = string
}

variable "cluster_token" {
  description = "The token of the EKS cluster."
  type        = string
  sensitive   = true
}

variable "cluster_ca_certificate" {
  description = "The CA certificate of the EKS cluster (Base64 encoded)."
  type        = string
  sensitive   = true
}
