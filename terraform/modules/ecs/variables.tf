variable "cluster_name" {
  description = "ECS Cluster name."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "min_size" {
  description = "Auto Scaling Group min size."
  type        = number
}

variable "max_size" {
  description = "Auto Scaling Group max size."
  type        = number
}

variable "desired_capacity" {
  description = "ECS cluster desired capacity."
  type        = number
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "target_group_arn_8080" {
  description = "The ARN of the target group for port 8080"
  type        = string
}

variable "production_listener_arn_8080" {
  description = "The ARN of the production listener for port 8080"
  type        = string
}

variable "dailyge_api_dev_url" {
  type = string
}

variable "dailyge_api_prod_url" {
  type = string
}
