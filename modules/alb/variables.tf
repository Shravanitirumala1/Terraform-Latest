
variable "alb_config" {
  description = "an object containing config parameters for an alb"
  type = object({
    name                             = string,
    internal                         = bool,
    security_group_ids               = list(string),
    subnet_ids                       = list(string),
    enable_deletion_protection       = bool,
    enable_cross_zone_load_balancing = bool,
    idle_timeout                     = number
  })
}

variable "target_group_configs" {
  description = "a map of objects containing config parameters for a set of target groups"
  type = map(object({
    name                 = string,
    port                 = number,
    protocol             = string,
    vpc_id               = string,
    target_type          = string,
    deregistration_delay = number,
    tags                 = map(string),
    health_check = object({
      enabled             = bool,
      interval            = number,
      path                = string,
      port                = string,
      protocol            = string,
      timeout             = number,
      healthy_threshold   = number,
      unhealthy_threshold = number,
      matcher             = string
    })
  }))
  default = {}
}

variable "listener_configs" {
  description = "a map of objects containing config parameters for a set of listeners"
  type = map(object({
    port            = number,
    protocol        = string,
    ssl_policy      = string,
    certificate_arn = string,
    default_action = object({
      type                 = string,
      target_group_arn_key = string,
      redirect             = map(string)
    })
  }))
  default = {}
}