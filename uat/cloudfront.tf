module "monarch_cdn" {
  source = "../modules/cloudfront"

  aliases = ["monarch-uat.welltowercloud.com"]

  comment             = "monarch-uat.welltowercloud.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:358646388167:global/webacl/IMPERVA-UAT/bc7f49b4-fbfb-4af9-8948-c4f39ad4c11a"

  #create_origin_access_identity = true
  #origin_access_identities = {
  # s3_bucket_one = "My awesome CloudFront can access"
  #}

  logging_config = {
    bucket = "well-cdn-logs.s3.amazonaws.com"
  }

  origin = {
    monarch = {
      domain_name = "monarch-uat-ingress-616255088.us-east-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  #http_port              = 80
  default_cache_behavior = {
    response_headers_policy_id = aws_cloudfront_response_headers_policy.no_index.id
    target_origin_id           = "monarch"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    #query_string    = true
    cache_policy_id          = aws_cloudfront_cache_policy.webapp.id          #"8e057be5-d0cf-40a8-b05f-06a70480d671" #aws_cloudfront_cache_policy.webapp.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.webapp.id #"8b71fd76-7741-43a6-bf64-f70b65d50db3" #aws_cloudfront_origin_request_policy.Web_Application.id
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/api/revalidate*"
      target_origin_id       = "monarch"
      viewer_protocol_policy = "https-only"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      #query_string    = true
      cache_policy_id          = aws_cloudfront_cache_policy.webhooks.id          #"8e057be5-d0cf-40a8-b05f-06a70480d671" #aws_cloudfront_cache_policy.webhooks_authorization.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
      origin_request_policy_id = aws_cloudfront_origin_request_policy.webhooks.id #"8b71fd76-7741-43a6-bf64-f70b65d50db3" #aws_cloudfront_origin_request_policy.Web_Hooks.id

      #aws_cloudfront_cache_policy.Cloudfront_Cache_Rule_Web_App.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:358646388167:certificate/5f69d571-d607-4076-80b0-f21fb430a0da"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}


module "venvi_cdn" {
  source = "../modules/cloudfront"

  aliases = ["venvi-uat.welltowercloud.com"]

  comment             = "venvi-uat.welltowercloud.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:358646388167:global/webacl/IMPERVA-UAT/bc7f49b4-fbfb-4af9-8948-c4f39ad4c11a"

  #create_origin_access_identity = true
  #origin_access_identities = {
  # s3_bucket_one = "My awesome CloudFront can access"
  #}

  logging_config = {
    bucket          = "well-cdn-logs.s3.amazonaws.com"
    include_cookies = true
    prefix          = "venvi"

  }

  origin = {
    venvi = {
      domain_name = "venvi-uat-ingress-965498054.us-east-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  #http_port              = 80
  default_cache_behavior = {
    response_headers_policy_id = aws_cloudfront_response_headers_policy.no_index.id
    target_origin_id           = "venvi"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    #query_string    = true
    cache_policy_id          = aws_cloudfront_cache_policy.webapp.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.webapp.id
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/api/revalidate*"
      target_origin_id       = "venvi"
      viewer_protocol_policy = "allow-all"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      #query_string    = true
      cache_policy_id          = aws_cloudfront_cache_policy.webhooks.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
      origin_request_policy_id = aws_cloudfront_origin_request_policy.webhooks.id

      #aws_cloudfront_cache_policy.Cloudfront_Cache_Rule_Web_App.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:358646388167:certificate/5f69d571-d607-4076-80b0-f21fb430a0da"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

module "frontier_cdn" {
  source = "../modules/cloudfront"

  aliases = ["frontier-uat.welltowercloud.com"]

  comment             = "frontier-uat.welltowercloud.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:358646388167:global/webacl/IMPERVA-UAT/bc7f49b4-fbfb-4af9-8948-c4f39ad4c11a"

  #create_origin_access_identity = true
  #origin_access_identities = {
  # s3_bucket_one = "My awesome CloudFront can access"
  #}

  logging_config = {
    bucket          = "well-cdn-logs.s3.amazonaws.com"
    include_cookies = true
    prefix          = "frontier"

  }

  origin = {
    frontier = {
      domain_name = "frontier-uat-ingress-983413195.us-east-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  #http_port              = 80
  default_cache_behavior = {
    response_headers_policy_id = aws_cloudfront_response_headers_policy.no_index.id
    target_origin_id           = "frontier"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    #query_string    = true
    cache_policy_id          = aws_cloudfront_cache_policy.webapp.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.webapp.id
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/api/revalidate*"
      target_origin_id       = "frontier"
      viewer_protocol_policy = "allow-all"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      #query_string    = true
      cache_policy_id          = aws_cloudfront_cache_policy.webhooks.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
      origin_request_policy_id = aws_cloudfront_origin_request_policy.webhooks.id

      #aws_cloudfront_cache_policy.Cloudfront_Cache_Rule_Web_App.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:358646388167:certificate/5f69d571-d607-4076-80b0-f21fb430a0da"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}