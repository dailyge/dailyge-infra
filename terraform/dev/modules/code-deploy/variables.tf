variable "application_name" {
  type        = string
  description = "The name of the CodeDeploy application"
}

variable "target_group_name_blue" {
  type        = string
  description = "The name of the blue target group for blue/green deployment"
}

variable "target_group_name_green" {
  type        = string
  description = "The name of the green target group for blue/green deployment"
}

variable "production_listener_arn" {
  type        = string
  description = "The ARN of the production ALB listener for traffic routing"
}

variable "test_listener_arn" {
  type        = string
  description = "The ARN of the test ALB listener for traffic routing"
}

variable "dev_ecr_arn" {
  type        = string
  description = "ARN of the development ECR repository"
}

variable "prod_ecr_arn" {
  type        = string
  description = "ARN of the production ECR repository"
}
