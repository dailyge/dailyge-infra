variable "name" {
  type        = string
  description = "Name."
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    zone = string
  }))
  description = "VPC public subnets."
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
  description = "Tags."
}
