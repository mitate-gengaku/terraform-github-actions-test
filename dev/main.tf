################################################
# VPC
################################################

module "vpc" {
  source = "../modules/vpc"

  cidr_block = "10.0.0.0/16"

  vpc_name = "shomotsu_development_vpc"
  env      = "development"
}

module "subnet" {
  source = "../modules/vpc_subnet"

  vpc_id = module.vpc.vpc_id
  env    = "development"
}

module "igw" {
  source = "../modules/vpc_igw"

  vpc_id = module.vpc.vpc_id
  name   = "shomotsu_development_internet_gateway"
  env    = "development"
}

module "route" {
  source = "../modules/vpc_route"

  cidr_block     = "0.0.0.0/0"
  route_table_id = module.route_tables.route_table_id
  gateway_id     = module.igw.igw_id
}

module "route_tables" {
  source = "../modules/vpc_route_tables"

  vpc_id                  = module.vpc.vpc_id
  public_route_table_name = "shomotsu_development_rtb_public"
  env                     = "development"
}

module "route_table_association" {
  source = "../modules/vpc_route_table_association"

  public_subnets       = module.subnet.public_subnets
  public_route_tables  = module.route_tables.public_route_tables
  private_subnets      = module.subnet.private_subnets
  private_route_tables = module.route_tables.private_route_tables
}

################################################
# ECR
################################################

module "ecr_repository" {
  source = "../modules/ecr"
}

################################################
# Security group
################################################

module "security_group" {
  source = "../modules/security_group"

  vpc_id = module.vpc.vpc_id
}

module "security_group_rule" {
  source = "../modules/security_group_rule"

  alb_sg_id         = module.security_group.alb_sg_id
  ecs_sg_id         = module.security_group.ecs_sg_id
  rds_sg_id         = module.security_group.rds_sg_id
  elasticache_sg_id = module.security_group.elasticache_sg_id
}

################################################
# Route 53
################################################

module "route53_record" {
  source = "../modules/route53_record"

  route53_domain_name = var.route53_domain_name
  domain_name = "dev.shomotsu.net"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id =  module.alb.alb_zone_id
}

################################################
# RDS
################################################

module "rds_subnet" {
  source = "../modules/rds_subnet"

  name        = "shomotsu_development_rds_subnet"
  description = "shomotsu development rds subnet"
  subnet_ids  = [for subnet in module.subnet.private_subnets : subnet.id]

  tags = {
    Name        = "Shomotsu Development RDS Subnet Group"
    Environment = "development"
  }
}

module "rds" {
  source = "../modules/rds"

  allocated_storage           = 10
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.35"
  identifier                  = "shomotsu-development-mysql-database-1"
  instance_class              = "db.t3.micro"
  username                    = "shomotsu_development_user"
  manage_master_user_password = true
  skip_final_snapshot         = true
  rds_sg_id                   = module.security_group.rds_sg_id
  subnet_id                   = module.rds_subnet.rds_subnet_id
  db_name = var.db_name
  
  dbpassword_name = var.dbpassword_name
  rds_username_paramete_name = var.rds_username_paramete_name
  rds_dbname_parameter_name = var.rds_dbname_parameter_name
  rds_parameter_name = var.rds_parameter_name

  tags = {
    Environment = "development"
  }
}

################################################
# Kms Key
################################################

module "kms" {
  source = "../modules/kms"

  description = "Key for ElastCache"
}

################################################
# ElastiCache
################################################

module "elasticache_subnet" {
  source = "../modules/elasticache_subnet"

  name        = "shomotsu-development-elasticache-subnet"
  description = "shomotsu development elasticache subnet"

  subnet_ids = [for subnet in module.subnet.private_subnets : subnet.id]

  tags = {
    Name        = "Shomotsu Development ElastiCache Subnet Group"
    Environment = "development"
  }
}

module "elasticache" {
  source = "../modules/elasticache"

  // name = "shomotsu-development-serverless-cache"
  name        = "lemp-test-redis"
  description = "shomotsu development serverless cache"

  data_storage_maximum = 10
  data_storage_unit    = "GB"

  kms_key_arn = module.kms.cache_key_arn

  security_group_ids = [
    module.security_group.elasticache_sg_id
  ]

  subnets = module.subnet.private_subnets
}

################################################
# S3
################################################

module "s3_bucket" {
  source = "../modules/s3"

  bucket_name = "shomotsu-development-bucket1"

  tags = {
    Name        = "shomotsu-development-bucket1"
    Environment = "development"
  }
}

module "s3_ownership" {
  source = "../modules/s3_ownership"

  bucket_id = module.s3_bucket.bucket_id
}

module "s3_bucket_policy" {
  source = "../modules/s3_bucket_policy"

  bucket_id  = module.s3_bucket.bucket_id
  bucket_arn = module.s3_bucket.bucket_arn

  source_arn = var.bucket_source_arn
}

################################################
# Cloudfront
################################################

module "cloudfront" {
  source = "../modules/cloudfront"

  image_acm_domain = var.image_acm_domain
  enabled = false

  origin_id                = module.s3_bucket.bucket_id
  domain_name              = module.s3_bucket.bucket_regional_domain_name
  origin_access_control_id = module.cloudfront_oac.cloudfront_oac_id

  target_origin_id = module.s3_bucket.bucket_id

  geo_restriction_type           = "none"
  cloudfront_default_certificate = false

  tags = {
    Environment = "development"
  }
}

module "cloudfront_oac" {
  source = "../modules/cloudfront_oac"

  name                              = "shomotsu_development_oac"
  description                       = "test oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


################################################
# Application Load Balancer
################################################

module "alb" {
  source = "../modules/alb"

  name     = "shomotsu-development-alb"
  internal = false
  security_groups = [
    module.security_group.alb_sg_id
  ]
  subnets = [for subnet in module.subnet.public_subnets : subnet.id]
}

module "alb_target_group" {
  source = "../modules/alb_target_group"

  name        = "shomotsu-development-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check_enabled  = true
  health_check_path     = "/health_check"
  health_check_interval = 300
}

module "alb_listener" {
  source = "../modules/alb_listener"

  load_balancer_arn = module.alb.alb_arn
  certificate_arn   = "arn:aws:acm:ap-northeast-1:${var.aws_account_id}:certificate/${var.shomotsu_acm_id}"
  target_group_arn  = module.alb_target_group.target_group_arn
}

################################################
# CloudWatch
################################################

module "cloudwatch_log" {
  source = "../modules/cloudwatch"

  name = "shomotsu-development-task-definition"
}

################################################
# ECS
################################################

module "ecs_cluster" {
  source = "../modules/ecs_cluster"

  name = "shomotsu-development-ecs-cluster"

  tags = {
    Environment = "development"
  }
}

module "ecs_task_definition" {
  source = "../modules/ecs-task-definition"

  family_name = "shomotsu-development-task-definition"

  secrets = [
    {
      "name" : "DB_HOST",
      "valueFrom" : module.rds.rds_host_ssm
    },
    {
      "name" : "DB_DATABASE",
      "valueFrom" : module.rds.rds_dbname_ssm
    },
    {
      "name" : "DB_USERNAME",
      "valueFrom" : module.rds.rds_username_ssm
    },
    {
      "name" : "DB_PASSWORD",
      "valueFrom" : module.rds.aws_rds_db_password_arn
    },
  ]

  env_s3 = var.env_s3
  nginx_container_image = var.nginx_container_image
  laravel_container_image = var.laravel_container_image
  task_role_arn = var.task_role_arn
  execution_role_arn = var.execution_role_arn

  tags = {
    Environment = "development"
  }
}

module "ecs" {
  source = "../modules/ecs"

  name       = "shomotsu_development_ecs_service"
  cluster_id = module.ecs_cluster.cluster_id

  public_subnets = [for subnet in module.subnet.public_subnets : subnet.id]

  security_groups = [
    module.security_group.ecs_sg_id
  ]

  task_definition_arn = module.ecs_task_definition.task_definition_arn

  target_group_arn = module.alb_target_group.target_group_arn

  load_balancer_container_name = module.ecs_task_definition.nginx_container_name

  tags = {
    Environment = "development"
  }
}