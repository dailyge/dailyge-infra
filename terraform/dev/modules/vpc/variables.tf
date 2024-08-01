variable "project_name" {
  type        = string
  description = "Project name."
}

variable "name" {
  type        = string
  description = "VPC name."
}

variable "cidr" {
  type        = string
  description = "VPC cidr block."
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "VPC private subnets."
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "List of private subnet configurations"
}

variable "monitoring_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "Dailyge monitoring subnets."
}

variable "document_db_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "Configuration for the MongoDB private subnet"
}

variable "redis_subnet" {
  description = "Configuration for the Redis private subnet"
  type        = object({
    cidr = string
    zone = string
  })
}

variable "rds_subnet" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "Configuration for the RDS subnets."
}

variable "rds_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "Configuration for the RDS subnets."
}

variable "nat_gateway_elastic_ip" {
  type = string
  description = "Nat-Gateway elastic ip."
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {
    Name        = "Dailyge"
    Environment = "Prod"
  }
}
