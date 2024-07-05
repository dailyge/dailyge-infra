variable "domain" {
  type        = string
  description = "CloudFront domain name of the S3 bucket."
}

variable "domain_name" {
  type        = string
  description = "The domain name for which to create Route 53 records."
}

variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "S3 bucket regional domain name used in CloudFront."
}

variable "cloudfront_distribution_id" {
  type        = string
  description = "The CloudFront distribution ID to link in Route 53."
}

variable "acm_certificate_arn" {
  type        = string
  sensitive   = true
  description = "ACM certificate ARN."
}

variable "cloudfront_distribution_domain_name" {
  type        = string
  description = "The domain name of the CloudFront distribution"
}

variable "ns_records" {
  type        = list(string)
  description = "List of name server records"
}
