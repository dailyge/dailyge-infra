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

### S3 ###
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

### CloudFront ###
variable "cnames" {
  type        = list(string)
  default     = []
  description = "CNAMES"
}

### ACM ###
variable "acm_certificate_arn" {
  type        = string
  sensitive   = true
  description = "ACM certificate ARN."
}

variable "application_name" {
  type = string
}

### ECS ###
variable "cluster_name" {
  type        = string
  description = "ECS Cluster Name."
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type."
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Auto Scaling Group min size."
}

variable "max_size" {
  type        = number
  default     = 2
  description = "Auto Scaling Group max size."
}

variable "desired_capacity" {
  type        = number
  description = "Auto Scaling Group capacity."
}

### Tags ###
variable "tags" {
  type        = map(string)
  description = "Tags."
}

