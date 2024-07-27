variable "key_name" {
  type        = string
  description = "Key name."
}

variable "cluster_name" {
  type        = string
  description = "ECS Cluster name."
}

variable "api_server_instance_type" {
  type        = string
  description = "Api Server instance type."
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
  description = "List of private subnet ids."
}

variable "target_group_arn_8080" {
  type        = string
  description = "Prod Server target group arn."
}

variable "alb_listener_arn_8080" {
  type        = string
  description = "Prod ALB listener arn."
}

variable "target_group_arn_8081" {
  description = "Dev Server target group arn."
  type        = string
}

variable "alb_listener_arn_8081" {
  type        = string
  description = "Dev ALB listener arn."
}

variable "dailyge_api_dev_url" {
  type = string
}

variable "dailyge_api_prod_url" {
  type = string
}
