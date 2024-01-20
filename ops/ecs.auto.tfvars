ecs_cluster_configs = {
  generalsites = {
    name               = "ST-SONARQUBE"
    capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  }
}

service_configs = {
  sq = {
    name                              = "st-sonarqube"
    launch_type                       = "FARGATE"
    scheduling_strategy               = "REPLICA"
    desired_count                     = 1
    health_check_grace_period_seconds = 60
    #iam_role                          = "aws-service-role"
    platform_version           = "1.4.0"
    tags                       = {}
    deployment_controller_type = "ECS"
    enable_ecs_managed_tags    = false
    ordered_placement_strategy = {}
  }
}