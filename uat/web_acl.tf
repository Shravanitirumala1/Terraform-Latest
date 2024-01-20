resource "aws_wafv2_web_acl" "imperva" {
  name        = "imp"
  description = "Example of a managed rule for imperva"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "imperva"
    sampled_requests_enabled   = false
  }

  rule {
    name     = "AWSIPList"
    priority = 0
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ipv4"
      sampled_requests_enabled   = false
    }
    action {
      allow {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = "arn:aws:wafv2:us-east-1:358646388167:global/ipset/IMPERVA/486fa779-fb65-47c2-bcfe-726cc72ed329"
          }
        }
        statement {
          ip_set_reference_statement {
            arn = "arn:aws:wafv2:us-east-1:358646388167:global/ipset/IMPERVA-IPv6/c8777c38-76f2-4b57-bff6-92f7aaeff37b"
          }
        }
      }
    }
  }
}
