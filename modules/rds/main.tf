
resource "aws_db_instance" "dbs" {
  for_each = var.db_instance_config

  identifier            = each.value["identifier"]
  engine                = each.value["engine"]
  instance_class        = each.value["instance_class"]
  allocated_storage     = each.value["allocated_storage"]
  max_allocated_storage = each.value["max_allocated_storage"]
  storage_encrypted     = true
  storage_type          = each.value["storage_type"]
  kms_key_id            = each.value["kms_key_id"]
  skip_final_snapshot   = each.value["skip_final_snapshot"]
  port                  = each.value["port"]
  username              = each.value["username"]
  password              = each.value["password"]
  license_model         = each.value["license_model"]
  snapshot_identifier   = each.value["snapshot_identifier"]

  auto_minor_version_upgrade = each.value["auto_minor_version_upgrade"]
  copy_tags_to_snapshot      = true
  deletion_protection        = each.value["deletion_protection"]

  enabled_cloudwatch_logs_exports = each.value["enabled_cloudwatch_logs_exports"]
  monitoring_interval             = each.value["monitoring_interval"]
  monitoring_role_arn             = each.value["monitoring_role_arn"]
  performance_insights_enabled    = each.value["performance_insights_enabled"]


  vpc_security_group_ids = each.value["vpc_security_group_ids"]
  db_subnet_group_name   = each.value["subnet_group_name"]

  tags = each.value["tags"]

}

resource "aws_db_subnet_group" "subnet_groups" {
  for_each = var.db_subnet_group_config

  name        = each.value["subnet_group_name"]
  description = each.value["subnet_group_description"]
  subnet_ids  = each.value["subnet_group_subnet_ids"]
  tags        = each.value["tags"]
}