variable "ecs_cluster_configs" {
  description = "a map of objects containing config parameters for ecs clusters"
  type = map(object({
    name               = string,
    capacity_providers = list(string)
  }))
}

variable "service_configs" {
  description = "a map of objects containing config parameters for a set of ecs services"
  type = map(object({
    name                              = string,
    launch_type                       = string,
    scheduling_strategy               = string,
    desired_count                     = number,
    health_check_grace_period_seconds = number,
    #iam_role                          = string,
    platform_version           = string,
    tags                       = map(string),
    deployment_controller_type = string,
    enable_ecs_managed_tags    = bool,
    ordered_placement_strategy = map(map(string))
  }))
}


data "aws_ecs_task_definition" "sq" {
  task_definition = "st-sonarqube"
}

# data "aws_ecs_task_definition" "sqtf" {
#   task_definition = "faf-sonarqube-sstf"
# }


module "st-sonarqube" {
  source         = "../modules/ecs-cluster"
  cluster_config = var.ecs_cluster_configs["generalsites"]

  service_configs = {
    sq = merge(
      var.service_configs["sq"],
      { load_balancer = {
        container_name   = "sonarqube"
        container_port   = 9000
        target_group_arn = module.sq_alb.target_groups["sq"].arn
      } },
      { network_config = {
        assign_public_ip = false
        security_groups  = [module.sq-sg.id]
        subnets          = [module.vpc.private_subnets[0].id, module.vpc.private_subnets[1].id]
      } },
      { task_definition = "${data.aws_ecs_task_definition.sq.family}:${data.aws_ecs_task_definition.sq.revision}" }
    )

  }
}