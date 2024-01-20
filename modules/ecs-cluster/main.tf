
resource "aws_ecs_cluster" "cluster" {
  name               = var.cluster_config["name"]
  # capacity_providers = var.cluster_config["capacity_providers"]
}

resource "aws_ecs_service" "services" {
  for_each                          = var.service_configs
  name                              = each.value["name"]
  cluster                           = aws_ecs_cluster.cluster.arn
  launch_type                       = each.value["launch_type"]
  scheduling_strategy               = each.value["scheduling_strategy"]
  task_definition                   = each.value["task_definition"]
  desired_count                     = each.value["desired_count"]
  health_check_grace_period_seconds = each.value["health_check_grace_period_seconds"]
  #iam_role                          = each.value["iam_role"]
  platform_version        = each.value["platform_version"]
  enable_ecs_managed_tags = each.value["enable_ecs_managed_tags"]
  tags                    = each.value["tags"]

  dynamic "load_balancer" {
    for_each = (each.value["load_balancer"]["target_group_arn"] == "" ? [] : [1])
    content {
      target_group_arn = each.value["load_balancer"]["target_group_arn"]
      container_name   = each.value["load_balancer"]["container_name"]
      container_port   = each.value["load_balancer"]["container_port"]
    }
  }

  dynamic "network_configuration" {
    for_each = (length(each.value["network_config"]["subnets"]) == 0 ? [] : [1])
    content {
      assign_public_ip = each.value["network_config"]["assign_public_ip"]
      security_groups  = each.value["network_config"]["security_groups"]
      subnets          = each.value["network_config"]["subnets"]
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = each.value["ordered_placement_strategy"]
    content {
      field = ordered_placement_strategy.value["field"]
      type  = ordered_placement_strategy.value["type"]
    }
  }

  deployment_controller {
    type = each.value["deployment_controller_type"]
  }
}