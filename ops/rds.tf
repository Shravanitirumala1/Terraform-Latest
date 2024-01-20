resource "aws_db_instance" "st-sonarqube" {
  identifier                      = "st-sonarqube"
  engine                          = "postgres"
  engine_version                  = "14.6"
  instance_class                  = "db.m5.large"
  port                            = 5432
  license_model                   = "postgresql-license"
  snapshot_identifier             = ""
  name                            = "sonarqube"
  username                        = var.rds_sonar_username
  password                        = var.rds_sonar_password
  auto_minor_version_upgrade      = false
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = []
  # monitoring_interval             = 60
  performance_insights_enabled = true
  # subnet_ids                      = [module.vpc.private_subnets[2].id, module.vpc.private_subnets[3].id]
  vpc_security_group_ids  = [module.sq-sg.id]
  allocated_storage       = 64
  db_subnet_group_name    = "sonarqube-sg"
  max_allocated_storage   = 256
  skip_final_snapshot     = true
  multi_az                = true
  backup_retention_period = 7
  apply_immediately       = true
}



resource "aws_db_subnet_group" "sonarqube-subnet-group" {
  name       = "sonarqube-sg"
  subnet_ids = [module.vpc.private_subnets[2].id, module.vpc.private_subnets[3].id]
}