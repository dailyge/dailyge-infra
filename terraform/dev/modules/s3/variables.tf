variable "domain_name" {
  type        = string
  description = "CloudFront distribution domain name."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
}

variable "cloudfront_distribution_arns" {
  type        = list(string)
  description = "CloudFront distribution arns."
}


#variable "cloudfront_distribution_arn" {
#  type        = string
#  sensitive   = true
#}

variable "bucket_name" {
  type        = string
  description = "S3 Bucket name."
}
