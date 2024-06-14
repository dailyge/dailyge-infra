variable "name" {
  type        = string
  description = "Name."
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "public_subnet" {
  type = object({
    cidr = string
    zone = string
  })
  description = "VPC public subnet."
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    zone = string
  }))
  description = "VPC private subnets."
}

variable "tags" {
  description = "Tags."
  type        = map(string)
}
