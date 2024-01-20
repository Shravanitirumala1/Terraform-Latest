resource "aws_cloudfront_cache_policy" "webapp" {
  name        = "Cloudfront_Cache_Rule_Web_Application"
  comment     = "Default cache rule for web application"
  default_ttl = 3600
  max_ttl     = 3600
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "all"
      # cookies {
      #   items = ["example"]
      # }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Accept"]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
      #query_strings {
      #  items = ["example"]
      #}
    }
  }
}

resource "aws_cloudfront_cache_policy" "webhooks" {
  name        = "Cloudfront_Cache_Rule_CTSK_Webhooks_Authorization"
  comment     = "Authorization Header"
  default_ttl = 0
  max_ttl     = 1
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "all"
      # cookies {
      #   items = ["example"]
      # }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["authorization"]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
      #query_strings {
      #  items = ["example"]
      #}
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "webapp" {
  name    = "CloudFront_Rules_Host_Headers_Web_Application"
  comment = "Default Origin Request Settings: Host Headers"
  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host"]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_origin_request_policy" "webhooks" {
  name    = "Cloudfront_Rule_CTSK_Webhooks"
  comment = "Host headers be included in origin request"
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }
}