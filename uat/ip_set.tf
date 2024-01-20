resource "aws_wafv2_ip_set" "impv4" {
  name               = "IMPERVA"
  description        = "IMPERVA IPs"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["199.83.128.0/21", "198.143.32.0/19", "149.126.72.0/21", "103.28.248.0/22", "45.64.64.0/22", "185.11.124.0/22", "192.230.64.0/18", "107.154.0.0/16", "45.60.0.0/16", "45.223.0.0/16", "131.125.128.0/17"]

  tags = {
    environment = "uat"
    Manged_by   = "Terraform"
  }
}

resource "aws_wafv2_ip_set" "impv6" {
  name               = "IMPERVA-IPv6"
  description        = "IMPERVA-IPv6"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV6"
  addresses          = ["2a02:e980::/29"]

  tags = {
    environment = "uat"
    Manged_by   = "Terraform"
  }
}

