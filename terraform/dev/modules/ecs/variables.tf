variable "cluster_name" {
  type        = string
  description = "ECS Cluster name."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "min_size" {
  type        = number
  description = "Auto Scaling Group min size."
}

variable "max_size" {
  type        = number
  description = "Auto Scaling Group max size."
}

variable "desired_capacity" {
  type        = number
  description = "ECS cluster desired capacity."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "target_group_arn_8080" {
  type        = string
  description = "The ARN of the target group for port 8080."
}

variable "alb_listener_arn_8080" {
  type        = string
  description = "The ARN of the listener for port 8080."
}

variable "target_group_arn_8081" {
  description = "The ARN of the target group for port 8081."
  type        = string
}


variable "alb_listener_arn_8081" {
  type        = string
  description = "The ARN of the listener for port 8081."
}

variable "dailyge_api_dev_url" {
  type = string
}

variable "dailyge_api_prod_url" {
  type = string
}
