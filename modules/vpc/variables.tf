variable "name" {
  type        = string
  description = "VPC name."
}

variable "cidr" {
  type        = string
  description = "VPC cidr block."
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    zone = string
  }))
  description = "VPC private subnets."
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    zone = string
  }))
  description = "VPC private subnets."
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {
    Name        = "Dailyge"
    Environment = "Prod"
  }
}
