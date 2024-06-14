module "vpc" {
  source = "./modules/vpc"

  cidr            = var.cidr
  name            = var.name
  public_subnet   = var.public_subnet
  private_subnets = var.private_subnets
  tags            = var.tags
}
