lb_configs = {
  sq = {
    name                             = "ST-SONARQUBE-ALB"
    internal                         = true
    enable_deletion_protection       = false
    enable_cross_zone_load_balancing = true
    idle_timeout                     = 60
  }
}


tg_configs = {

  sq = {
    name                 = "ST-SONARQUBE"
    port                 = 9000
    protocol             = "HTTP"
    target_type          = "ip"
    deregistration_delay = 300
    tags                 = {}
    health_check = {
      enabled             = true
      interval            = 30
      path                = "/"
      port                = "9000"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 5
      unhealthy_threshold = 2
      matcher             = "200"
    }
  }

}

listener_configs = {

  # sq_https = {
  #     port       = 443
  #     protocol   = "HTTPS"
  #     ssl_policy = "ELBSecurityPolicy-2016-08"
  #     default_action = {
  #       type                 = "forward"
  #       target_group_arn_key = "sq"
  #       redirect             = {}
  #     }
  #   }
  sq_http = {
    port       = 80
    protocol   = "HTTP"
    ssl_policy = ""
    default_action = {
      type                 = "forward" #"redirect"
      target_group_arn_key = "sq"
      redirect = {
        # host        = "#{host}"
        # port        = 443
        # path        = "/#{path}"
        # protocol    = "HTTPS"
        # query       = "#{query}"
        # status_code = "HTTP_301"
      }
    }
  }
}
