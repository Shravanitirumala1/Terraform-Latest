variable "lb_configs" {
  description = "an map of objects containing config parameters for load balancers"
  type = map(object({
    name                             = string,
    internal                         = bool,
    enable_deletion_protection       = bool,
    enable_cross_zone_load_balancing = bool,
    idle_timeout                     = number
  }))
}


variable "tg_configs" {
  description = "a maps of objects containing config parameters for target groups"
  type = map(object({
    name                 = string,
    port                 = number,
    protocol             = string,
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
}


variable "listener_configs" {
  description = "a map of objects containing config parameters for a set of listeners"
  type = map(object({
    port       = number,
    protocol   = string,
    ssl_policy = string,
    default_action = object({
      type                 = string,
      target_group_arn_key = string,
      redirect             = map(string)
    })
  }))
  default = {}
}

module "sq_alb" {
  source = "../modules/alb"
  alb_config = merge(
    var.lb_configs["sq"],
    { security_group_ids = [module.sq-sg.id] },
    { subnet_ids = [module.vpc.private_subnets[0].id, module.vpc.private_subnets[1].id] }
  )

  target_group_configs = {
    sq = merge(
      var.tg_configs["sq"],
      { vpc_id = module.vpc.vpc }
    )
  }
  listener_configs = {
    #https = merge(
    #  var.listener_configs["sq_https"],
    #  { certificate_arn = ""} #module.acm.acm_certificate_arn"" }
    #)
    http = merge(
      var.listener_configs["sq_http"],
      { certificate_arn = "" }
    )
  }
}

#module "sqtf_alb" {
#  source = "../modules/alb"
#  alb_config = merge(
#    var.lb_configs["sqtf"],
#    { security_group_ids = [module.sqtf-sg.id] },
#    { subnet_ids = [module.vpc.public_subnets[0].id, module.vpc.public_subnets[1].id] }
#  )
#
#  target_group_configs = {
#    sqtf = merge(
#      var.tg_configs["sqtf"],
#      { vpc_id = module.vpc.vpc }
#    )
#  }
#
#  listener_configs = {
#    http = merge(
#      var.listener_configs["sqtf_http"],
#      { certificate_arn = "" }
#    )
#  }
#}
