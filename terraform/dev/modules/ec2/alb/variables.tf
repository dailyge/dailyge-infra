variable "name" {
  type        = string
  description = "ALB name."
}

variable "public_subnets_ids" {
  type        = list(string)
  description = "ALB subnet ids."
}

variable "alb_security_group_id" {
  type        = string
  description = "ALB Security group id."
}

variable "vpc_id" {
  type        = string
  description = "ALB VPC id."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
}
