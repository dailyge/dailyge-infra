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

variable "target_group_arn" {
  description = "The ARN of the target group for the ALB"
  type        = string
}

variable "production_listener_arn" {
  description = "The ARN of the production listener"
  type        = string
}
