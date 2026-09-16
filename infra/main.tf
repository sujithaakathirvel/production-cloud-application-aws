module "vpc" {
  source = "./modules/vpc"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  alb_sg_id  = module.security.alb_sg_id
}

module "ecs" {
  source           = "./modules/ecs"
  subnet_ids       = module.vpc.subnet_ids
  ecs_sg_id        = module.security.ecs_sg_id
  target_group_arn = module.alb.target_group_arn
  ecr_repo_url     = module.ecr.repository_url
  db_secret_arn    = aws_secretsmanager_secret.db_credentials.arn
  db_host          = module.rds.db_endpoint
}

module "rds" {
  source      = "./modules/rds"
  subnet_ids  = module.vpc.subnet_ids
  rds_sg_id   = module.security.rds_sg_id
  db_password = var.db_password
}

module "ecr" {
  source = "./modules/ecr"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/cloud-task"
  retention_in_days = 7
}


resource "aws_secretsmanager_secret" "db_credentials" {
  name = "cloud-task-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = var.db_password
}
