module "vpc" {
  source = "./modules/vpc"

  cidr            = var.cidr
  name            = var.name
  public_subnets  = var.public_subnets
  private_subnets = var.dailyge_api_private_subnets
  tags            = var.tags
  redis_subnet    = var.redis_subnet
  rds_subnet      = var.rds_subnets
  rds_subnets     = var.rds_subnets
}

module "alb" {
  source                = "./modules/ec2/alb"
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
  s3_bucket_regional_domain_name = var.bucket_url
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
  instance_type         = var.redis_instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.dailyge_api_private_subnet_ids
  target_group_arn_8080 = module.alb.target_group_arn_8080
  target_group_arn_8081 = module.alb.target_group_arn_8081
  alb_listener_arn_8080 = module.alb.listener_arn_8080
  alb_listener_arn_8081 = module.alb.listener_arn_8081
  dailyge_api_dev_url   = module.ecr.dailyge_api_dev_url
  dailyge_api_prod_url  = module.ecr.dailyge_api_prod_url
  depends_on            = [module.alb]
}

module "security_group" {
  source = "./modules/ec2/security-group"
  vpc_id = module.vpc.vpc_id
}

module "ec2_instance" {
  source                   = "./modules/ec2/instance"
  redis_instance_ami_id    = var.redis_instance_ami_id
  redis_instance_type      = var.redis_instance_type
  key_name                 = var.key_name
  redis_subnet_id          = module.vpc.redis_subnet_id
  redis_security_group_ids = [module.security_group.redis_security_group_id]
}

module "rds" {
  source                 = "./modules/rds"
  rds_security_group_ids = [module.security_group.rds_security_group_id]
  db_subnet_group_name   = var.db_subnet_group_name
  password               = var.rds_password
  rds_subnet_ids         = module.vpc.rds_subnet_ids
  username               = var.rds_user
  depends_on             = [module.vpc]
}
