variable "rds_subnet_ids" {
  type        = list(string)
  description = ""
}

variable "rds_security_group_ids" {
  type        = string
  description = ""
}

variable "db_subnet_group_name" {
  type        = string
  description = "RDS subnet group name."
}

variable "username" {
  type        = string
  description = "RDS username."
}

variable "password" {
  type        = string
  description = "RDS password."
  sensitive   = true
}
