variable "db_instance_config" {
  description = "a set of object that describe the config of db instances"
  type = map(object({
    identifier                      = string,
    engine                          = string,
    instance_class                  = string,
    allocated_storage               = number,
    max_allocated_storage           = number,
    storage_type                    = string,
    kms_key_id                      = string,
    skip_final_snapshot             = bool,
    port                            = number,
    license_model                   = string,
    snapshot_identifier             = string,
    username                        = string,
    password                        = string,
    auto_minor_version_upgrade      = bool,
    deletion_protection             = bool,
    enabled_cloudwatch_logs_exports = list(string),
    monitoring_interval             = number,
    monitoring_role_arn             = string,
    performance_insights_enabled    = bool,
    vpc_security_group_ids          = list(string),
    tags                            = map(string),
    subnet_group_name               = string
  }))
}

variable "db_subnet_group_config" {
  description = "a map fo object that contain config parameters for a set fo db subnet groups"
  type = map(object({
    subnet_group_name        = string,
    subnet_group_description = string,
    subnet_group_subnet_ids  = list(string),
    tags                     = map(string)
  }))
}