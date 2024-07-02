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
  type = list(object({
    cidr = string
    zone = string
  }))
  description = "List of private subnet configurations"
}

variable "redis_subnet" {
  description = "Configuration for the Redis private subnet"
  type        = object({
    cidr = string
    zone = string
  })
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {
    Name        = "Dailyge"
    Environment = "Prod"
  }
}
