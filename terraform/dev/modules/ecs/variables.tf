variable "key_name" {
  type        = string
  description = "Key name."
}

variable "cluster_name" {
  type        = string
  description = "ECS Cluster name."
}

variable "ecs_security_group_id" {
  type = string
  description = "ECS security group id."
}

variable "rds_security_group_id" {
  type = string
  default = "RDS security group id."
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

variable "target_group_arn_8081" {
  description = "Dev Server target group arn."
  type        = string
}

variable "target_group_arn_443" {
  type        = string
  description = "HTTPS target group arn."
}

variable "dailyge_api_dev_url" {
  type = string
}

variable "dailyge_api_prod_url" {
  type = string
}
