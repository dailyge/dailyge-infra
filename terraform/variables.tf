variable "name" {
  type        = string
  description = "Resource name."
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    zone = string
  }))
  description = "VPC public subnets."
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    zone = string
  }))
  description = "VPC private subnets."
}

variable "bucket_name" {
  type        = string
  description = "S3 Bucket name."
}

variable "domain_name" {
  type        = string
  description = "CloudFront domain name of the S3 bucket."
}

variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "S3 bucket the regional domain name."
}

variable "cnames" {
  type        = list(string)
  default     = []
  description = "CNAMES"
}

variable "acm_certificate_arn" {
  type        = string
  sensitive   = true
  description = "ACM certificate ARN."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
}
