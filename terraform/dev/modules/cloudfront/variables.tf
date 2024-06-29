variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "S3 Bucket regional domain."
}

variable "bucket_name" {
  type        = string
  description = "Bucket name."
}

variable "bucket_id" {
  type        = string
  description = "Bucket id."
}

variable "cnames" {
  description = "CNAMES."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  type        = string
  sensitive   = true
  description = "ACM certificate ARN"
}

variable "tags" {
  type        = map(string)
  description = "Tags."
}
