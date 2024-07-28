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

variable "aws_cert_arn" {
  type        = string
  description = "ALB cert_arn."
}

variable "api_docs_instance_id" {
  type        = string
  description = "API docs instance id."
}

variable "monitoring_instance_ip" {
  type        = string
  description = "Sonarqube instance id."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
}
