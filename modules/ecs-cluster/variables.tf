
variable "cluster_config" {
  description = "a map of objects containing config parameters for a set of ecs cluster"
  type = object({
    name               = string,
    capacity_providers = list(string)
  })
}


variable "service_configs" {
  description = "a map of objects containing config parameters for a set of ecs services"
  type = map(object({
    name                              = string,
    launch_type                       = string,
    scheduling_strategy               = string,
    task_definition                   = string,
    desired_count                     = number,
    health_check_grace_period_seconds = number,
    #iam_role                          = string,
    platform_version           = string,
    tags                       = map(string),
    deployment_controller_type = string,
    enable_ecs_managed_tags    = bool,
    ordered_placement_strategy = map(map(string)),
    load_balancer = object({
      container_name   = string,
      container_port   = number,
      target_group_arn = string
    }),
    network_config = object({
      assign_public_ip = bool
      security_groups  = list(string)
      subnets          = list(string)
    })
  }))
  default = {}
}