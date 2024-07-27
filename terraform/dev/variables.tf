variable "project_name" {
  type        = string
  description = "Project name."
}

variable "alb_acm_cert_arn" {
  type        = string
  description = "ALB acm_cert name."
}

variable "acm_cert_name" {
  type        = string
  description = "acm_cert name."
}

variable "acm_cert_records" {
  type        = list(string)
  description = "acm_cert name."
}

variable "name" {
  type        = string
  description = "Resource name."
}

variable "ns_records" {
  type        = list(string)
  description = "List of NS records"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "document_db_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "DocumentDB subnets."
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "VPC public subnets."
}

variable "dailyge_api_private_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "VPC private subnets."
}

variable "dailyge_monitoring_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "monitoring subnets."
}

### S3 ###
variable "bucket_name" {
  type        = string
  description = "S3 Bucket name."
}

variable "region" {
  type        = string
  description = "CloudFront domain name of the S3 bucket."
}

variable "bucket_url" {
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

/**
* EC2.
*/
variable "sonarqube_instance_ip" {
  type        = string
  description = "Sonarqube ID"
}

variable "bastion_instance_id" {
  type        = string
  description = "Sonarqube ID"
}

variable "bastion_instance_ami_id" {
  type        = string
  description = "The AMI ID for the bastion instance"
}

variable "bastion_instance_type" {
  type        = string
  description = "The type of instance to start."
}

variable "redis_instance_ami_id" {
  type        = string
  description = "The AMI ID to use for the instance."
}

variable "redis_instance_type" {
  type        = string
  description = "The type of instance to start."
}

variable "api_server_instance_type" {
  type        = string
  description = "Api Server instance type."
}

variable "key_name" {
  type        = string
  description = "The name of the key pair to use for the instance."
}

variable "redis_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The security groups to associate with the instance."
}

variable "redis_subnet" {
  type = object({
    cidr = string
    zone = string
  })
  description = "Configuration for the Redis private subnet"
}

### RDS ###
variable "rds_user" {
  type        = string
  description = "Username."
}

variable "rds_password" {
  type        = string
  description = "Password."
  sensitive   = true
}

variable "rds_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The security groups to associate with the instance."
}

variable "rds_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "Configuration for the RDS subnets."
}

variable "db_subnet_group_name" {
  type        = string
  description = "RDS subnet group name."
}

### Tags ###
variable "tags" {
  type        = map(string)
  description = "Tags."
}
