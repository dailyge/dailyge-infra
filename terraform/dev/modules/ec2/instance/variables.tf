variable "bastion_instance_ami_id" {
  description = "The AMI ID to use for the instance."
  type        = string
}

variable "bastion_instance_type" {
  type        = string
  description = "The type of instance to start."
}

variable "bastion_subnet_id" {
  type        = string
  description = "The VPC subnet ID to launch in."
}

variable "bastion_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The bastion security groups to associate with the instance."
}

variable "redis_instance_ami_id" {
  description = "The AMI ID to use for the instance."
  type        = string
}

variable "redis_instance_type" {
  type        = string
  description = "The type of instance to start."
}

variable "key_name" {
  type        = string
  default     = ""
  description = "The name of the key pair to use for the instance."
}

variable "redis_subnet_id" {
  type        = string
  description = "The VPC subnet ID to launch in."
}

variable "redis_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The security groups to associate with the instance."
}
