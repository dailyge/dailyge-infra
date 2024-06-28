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

variable "application_name" {
  type = string
}

### ECS ###
variable "cluster_name" {
  description = "ECS Cluster Name."
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type."
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Auto Scaling Group min size."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Auto Scaling Group max size."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Auto Scaling Group capacity."
  type        = number
  default     = 1
}

### Tags ###
variable "tags" {
  type        = map(string)
  description = "Tags."
}

