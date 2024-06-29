module "vpc" {
  source = "./modules/vpc"

  cidr            = var.cidr
  name            = var.name
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "alb" {
  source                = "./modules/alb"
  name                  = var.name
  public_subnets_ids    = module.vpc.public_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  vpc_id                = module.vpc.vpc_id
  tags                  = var.tags
}

module "s3" {
  source                      = "./modules/s3"
  bucket_name                 = module.s3.bucket_name
  domain_name                 = "www.dailyge.com"
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  tags                        = var.tags
}

module "cloudfront" {
  source                         = "./modules/cloudfront"
  bucket_id                      = module.s3.bucket_id
  bucket_name                    = module.s3.bucket_name
  s3_bucket_regional_domain_name = var.s3_bucket_regional_domain_name
  cnames                         = var.cnames
  acm_certificate_arn            = var.acm_certificate_arn
  tags                           = var.tags
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source                = "./modules/ecs"
  cluster_name          = var.cluster_name
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_arn_8080 = module.alb.target_group_arn_8080
  target_group_arn_8081 = module.alb.target_group_arn_8081
  alb_listener_arn_8080 = module.alb.listener_arn_8080
  alb_listener_arn_8081 = module.alb.listener_arn_8081
  dailyge_api_dev_url   = module.ecr.dailyge_api_dev_url
  dailyge_api_prod_url  = module.ecr.dailyge_api_prod_url
  depends_on            = [module.alb]
}
