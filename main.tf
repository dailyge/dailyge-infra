module "vpc" {
  source = "./modules/vpc"

  cidr            = var.cidr
  name            = var.name
  public_subnets   = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}
