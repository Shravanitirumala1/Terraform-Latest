module "monarch_cdn" {
  source = "../modules/cloudfront"

  aliases = ["www.monarchcommunities.com", "monarchcommunities.com"]

  comment             = "www.monarchcommunities.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:602837221957:global/webacl/IMPERVA-PROD/11008a32-2b39-4843-b98e-9746d9d46a46"
  #create_origin_access_identity = true
  #origin_access_identities = {
  # s3_bucket_one = "My awesome CloudFront can access"
  #}

  logging_config = {
    bucket          = "well-prod-cdn-logs.s3.amazonaws.com"
    include_cookies = true
    prefix          = "monarch"

  }

  origin = {
    monarch = {
      domain_name = "monarch-prod-ingress-1697182947.us-east-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  #http_port              = 80
  default_cache_behavior = {
    target_origin_id       = "monarch"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    #query_string    = true
    cache_policy_id          = "a85e58ea-aff7-4a41-bf42-e78e1f38bafa" #aws_cloudfront_cache_policy.webapp.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
    origin_request_policy_id = "b20c8bcd-cf89-40d5-9c6f-70aad1be1f9e" #aws_cloudfront_origin_request_policy.Web_Application.id
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
      cache_policy_id          = "06b38adf-bd2d-4f87-beca-2473dc8c7d22" #aws_cloudfront_cache_policy.webhooks_authorization.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
      origin_request_policy_id = "da9a9c0f-719e-487d-92e3-c8eaa4b75fe6" #aws_cloudfront_origin_request_policy.Web_Hooks.id

      #aws_cloudfront_cache_policy.Cloudfront_Cache_Rule_Web_App.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:602837221957:certificate/af96d582-9107-4ba0-8584-abde74190122"
    ssl_support_method  = "sni-only"
  }
}
############################################

module "venvi_cdn" {
  source = "../modules/cloudfront"

  aliases = ["www.venviliving.com", "venviliving.com"]

  comment             = "www.venviliving.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:602837221957:global/webacl/IMPERVA-PROD/11008a32-2b39-4843-b98e-9746d9d46a46"
  #create_origin_access_identity = true
  #origin_access_identities = {
  # s3_bucket_one = "My awesome CloudFront can access"
  #}

  logging_config = {
    bucket          = "well-prod-cdn-logs.s3.amazonaws.com"
    include_cookies = true
    prefix          = "venvi"

  }

  origin = {
    venvi = {
      domain_name = "venvi-prod-ingress-1608713078.us-east-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  #http_port              = 80
  default_cache_behavior = {
    target_origin_id       = "venvi"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    #query_string    = true
    cache_policy_id          = "a85e58ea-aff7-4a41-bf42-e78e1f38bafa" #aws_cloudfront_cache_policy.webapp.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
    origin_request_policy_id = "b20c8bcd-cf89-40d5-9c6f-70aad1be1f9e" #aws_cloudfront_origin_request_policy.Web_Application.id
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/api/revalidate*"
      target_origin_id       = "venvi"
      viewer_protocol_policy = "https-only"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      #query_string    = true
      cache_policy_id          = "06b38adf-bd2d-4f87-beca-2473dc8c7d22" #aws_cloudfront_cache_policy.webhooks_authorization.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
      origin_request_policy_id = "da9a9c0f-719e-487d-92e3-c8eaa4b75fe6" #aws_cloudfront_origin_request_policy.Web_Hooks.id

      #aws_cloudfront_cache_policy.Cloudfront_Cache_Rule_Web_App.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:602837221957:certificate/1be8005b-cb95-4b13-b64f-0e8c68e56e53" #"arn:aws:acm:us-east-1:602837221957:certificate/b532272b-98a6-4621-b1a6-389d3db87b63"
    ssl_support_method  = "sni-only"
  }
}
############################################################################

module "frontier_cdn" {
  source = "../modules/cloudfront"

  aliases = ["locations.frontiermgmt.com"]

  comment             = "locations.frontiermgmt.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:602837221957:global/webacl/IMPERVA-PROD/11008a32-2b39-4843-b98e-9746d9d46a46"
  #create_origin_access_identity = true
  #origin_access_identities = {
  # s3_bucket_one = "My awesome CloudFront can access"
  #}

  logging_config = {
    bucket          = "well-prod-cdn-logs.s3.amazonaws.com"
    include_cookies = true
    prefix          = "frontier"

  }

  origin = {
    frontier = {
      domain_name = "frontier-prod-ingress-902636092.us-east-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  #http_port              = 80
  default_cache_behavior = {
    target_origin_id       = "frontier"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    #query_string    = true
    cache_policy_id          = aws_cloudfront_cache_policy.webapp.id          #"a85e58ea-aff7-4a41-bf42-e78e1f38bafa" #aws_cloudfront_cache_policy.webapp.id #"8e057be5-d0cf-40a8-b05f-06a70480d671"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.webapp.id #"b20c8bcd-cf89-40d5-9c6f-70aad1be1f9e" #aws_cloudfront_origin_request_policy.webhooks
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/api/revalidate*"
      target_origin_id       = "frontier"
      viewer_protocol_policy = "https-only"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      #query_string    = true
      cache_policy_id          = aws_cloudfront_cache_policy.webhooks.id          #"06b38adf-bd2d-4f87-beca-2473dc8c7d22" #aws_cloudfront_cache_policy.webhooks #"8e057be5-d0cf-40a8-b05f-06a70480d671"
      origin_request_policy_id = aws_cloudfront_origin_request_policy.webhooks.id #"da9a9c0f-719e-487d-92e3-c8eaa4b75fe6" #aws_cloudfront_origin_request_policy.Web_Hooks.id

      #aws_cloudfront_cache_policy.Cloudfront_Cache_Rule_Web_App.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:602837221957:certificate/6ba33b30-ccdc-40d7-ba88-f86e7989be98"
    ssl_support_method  = "sni-only"
  }
}

########################################################################################################################
