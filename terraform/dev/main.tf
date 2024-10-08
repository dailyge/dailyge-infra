module "ec2_instance" {
  source                  = "./modules/ec2/instance"
  bastion_instance_ami_id = var.bastion_instance_ami_id
  bastion_instance_type   = var.bastion_instance_type
  redis_instance_type     = var.redis_instance_type
  key_name                = var.key_name
  redis_instance_ami_id   = var.redis_instance_ami_id
  bastion_subnet_id       = module.vpc.public_subnet_ids[0]
  redis_subnet_id         = module.vpc.redis_subnet_id
}

module "elastic_ip" {
  source              = "./modules/ec2/eip"
  bastion_instance_id = module.vpc.public_subnet_ids[0]
}

module "vpc" {
  source                 = "./modules/vpc"
  project_name           = var.project_name
  cidr                   = var.cidr
  name                   = var.name
  public_subnets         = var.public_subnets
  private_subnets        = var.dailyge_api_private_subnets
  monitoring_subnets     = var.dailyge_monitoring_subnets
  document_db_subnets    = var.document_db_subnets
  tags                   = var.tags
  redis_subnet           = var.redis_subnet
  rds_subnet             = var.rds_subnets
  rds_subnets            = var.rds_subnets
  nat_gateway_elastic_ip = module.elastic_ip.nat_gateway_elastic_ip
}

module "ecs" {
  source                                     = "./modules/ecs"
  cluster_name                               = var.cluster_name
  min_size                                   = var.min_size
  max_size                                   = var.max_size
  desired_capacity                           = var.desired_capacity
  api_server_instance_type                   = var.api_server_instance_type
  key_name                                   = var.key_name
  vpc_id                                     = module.vpc.vpc_id
  private_subnet_ids                         = module.vpc.dailyge_api_private_subnet_ids
  dailyge_api_target_group_arn_8080          = module.alb.dailyge_api_target_group_arn_8080
  dailyge_api_target_group_arn_8081          = module.alb.dailyge_api_target_group_arn_8081
  admin_api_canary_target_group_arn_8080     = module.alb.admin_api_canary_target_group_arn_8080
  admin_api_canary_target_group_arn_8081     = module.alb.admin_api_canary_target_group_arn_8081
  admin_api_production_target_group_arn_8080 = module.alb.admin_api_production_target_group_arn_8080
  admin_api_production_target_group_arn_8081 = module.alb.admin_api_production_target_group_arn_8081
  target_group_arn_443                       = module.alb.https_target_group_arn_https
  dailyge_admin_api_prod_url                 = module.ecr.dailyge_admin_api_prod_url
  dailyge_admin_api_dev_url                  = module.ecr.dailyge_admin_api_dev_url
  dailyge_api_dev_url                        = module.ecr.dailyge_api_dev_url
  dailyge_api_prod_url                       = module.ecr.dailyge_api_prod_url
  ecs_security_group_id                      = module.security_group.ecs_security_group_id
  rds_security_group_id                      = module.security_group.rds_security_group_id
  depends_on                                 = [module.alb]
#  admin_api_group_id                         = module.codedeploy.codedeploy_deployment_group_id
}

module "alb" {
  source                 = "./modules/ec2/alb"
  project_name           = var.project_name
  aws_cert_arn           = var.alb_acm_cert_arn
  monitoring_instance_id = var.sonarqube_instance_ip
  public_subnets_ids     = module.vpc.public_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  alb_security_group_ids = [module.security_group.alb_security_group_ids]
}

module "route53" {
  source                              = "./modules/route53"
  domain                              = "dailyge.com"
  domain_name                         = "dailyge.com"
  region                              = var.region
  ns_records                          = var.ns_records
  acm_cert_name                       = var.acm_cert_name
  acm_cert_records                    = var.acm_cert_records
  acm_certificate_arn                 = var.acm_certificate_arn
  alb_dns_name                        = module.alb.alb_dns_name
  host_zone_id                        = module.alb.alb_host_zone
  cloudfront_distribution_domain_name = module.cloudfront.main_prod_distribution_domain_name
  cloudfront_distribution_id          = module.cloudfront.main_prod_cloudfront_distribution_id
  s3_bucket_regional_domain_name      = module.s3.bucket_regional_domain_name
}

module "s3" {
  source                       = "./modules/s3"
  domain_name                  = "www.dailyge.com"
  tags                         = var.tags
  bucket_name                  = module.s3.bucket_name
  cloudfront_distribution_arns = [
    module.cloudfront.main_prod_distribution_arn,
    module.cloudfront.tasks_prod_distribution_arn,
    module.cloudfront.tasks_dev_distribution_arn
  ]
}

module "cloudfront" {
  source                         = "./modules/cloudfront"
  s3_bucket_regional_domain_name = var.bucket_url
  cnames                         = var.cnames
  acm_certificate_arn            = var.acm_certificate_arn
  tags                           = var.tags
  bucket_id                      = module.s3.bucket_id
  bucket_name                    = module.s3.bucket_name
  depends_on                     = [module.vpc]
}

module "ecr" {
  source = "./modules/ecr"
}

module "aws_secretsmanager_secret" {
  source = "./modules/secret-manager"
}

module "security_group" {
  source = "./modules/ec2/security-group"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source                 = "./modules/rds"
  username               = var.rds_user
  password               = var.rds_password
  db_subnet_group_name   = var.db_subnet_group_name
  rds_security_group_ids = module.security_group.rds_security_group_id
  rds_subnet_ids         = module.vpc.rds_subnet_ids
  depends_on             = [module.vpc]
}

module "sqs" {
  source = "./modules/sqs"
}

module "sns" {
  source                      = "./modules/sns"
  dailyge_sqs_event_queue_arn = module.sqs.dailyge_event_sqs_arn
}

module "codedeploy" {
  source                                     = "./modules/code-deploy"
#  dailyge_alb_listener                       = module.alb.alb_https_listener_arn
#  admin_api_canary_target_group_8080_arn     = module.alb.admin_api_canary_target_group_arn_8080
#  admin_api_canary_target_group_8081_arn     = module.alb.admin_api_canary_target_group_arn_8081  # 수정된 부분
#  admin_api_production_target_group_8080_arn = module.alb.admin_api_production_target_group_arn_8080
#  admin_api_production_target_group_8081_arn = module.alb.admin_api_production_target_group_arn_8081
}

