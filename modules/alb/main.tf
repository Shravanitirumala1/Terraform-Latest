
resource "aws_lb" "this" {
  name                             = var.alb_config["name"]
  internal                         = var.alb_config["internal"]
  load_balancer_type               = "application"
  security_groups                  = var.alb_config["security_group_ids"]
  subnets                          = var.alb_config["subnet_ids"]
  enable_deletion_protection       = var.alb_config["enable_deletion_protection"]
  enable_cross_zone_load_balancing = var.alb_config["enable_cross_zone_load_balancing"]
  idle_timeout                     = var.alb_config["idle_timeout"]
}

resource "aws_lb_target_group" "target_groups" {
  for_each             = var.target_group_configs
  name                 = each.value["name"]
  port                 = each.value["port"]
  protocol             = each.value["protocol"]
  vpc_id               = each.value["vpc_id"]
  target_type          = each.value["target_type"]
  deregistration_delay = each.value["deregistration_delay"]
  tags                 = each.value["tags"]

  health_check {
    enabled             = each.value["health_check"]["enabled"]
    interval            = each.value["health_check"]["interval"]
    path                = each.value["health_check"]["path"]
    port                = each.value["health_check"]["port"]
    protocol            = each.value["health_check"]["protocol"]
    timeout             = each.value["health_check"]["timeout"]
    healthy_threshold   = each.value["health_check"]["healthy_threshold"]
    unhealthy_threshold = each.value["health_check"]["unhealthy_threshold"]
    matcher             = each.value["health_check"]["matcher"]
  }
}

resource "aws_lb_listener" "listeners" {
  for_each          = var.listener_configs
  load_balancer_arn = aws_lb.this.arn
  port              = each.value["port"]
  protocol          = each.value["protocol"]
  ssl_policy        = each.value["ssl_policy"]
  certificate_arn   = each.value["certificate_arn"]

  dynamic "default_action" {
    for_each = toset(each.value["default_action"]["type"] == "forward" ? ["1"] : [])
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.target_groups[each.value["default_action"]["target_group_arn_key"]].arn
    }
  }

  dynamic "default_action" {
    for_each = toset(each.value["default_action"]["type"] == "redirect" ? ["1"] : [])
    content {
      type = "redirect"
      redirect {
        host        = each.value["default_action"]["redirect"]["host"]
        port        = each.value["default_action"]["redirect"]["port"]
        path        = each.value["default_action"]["redirect"]["path"]
        protocol    = each.value["default_action"]["redirect"]["protocol"]
        query       = each.value["default_action"]["redirect"]["query"]
        status_code = each.value["default_action"]["redirect"]["status_code"]
      }
    }
  }

}

