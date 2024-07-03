variable "project_name" {
  type        = string
  description = "ALB name."
}

variable "public_subnets_ids" {
  type        = list(string)
  description = "ALB subnet ids."
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "ALB security group ids."
}

variable "vpc_id" {
  type        = string
  description = "ALB vpc id."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
}
