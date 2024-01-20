data "aws_key_pair" "prod" {
  key_name           = "st-prod-eks"
  include_public_key = true
  #filter {
  #  name   = "tag:Component"
  #  values = ["web"]
  #}
}

data "aws_route53_zone" "ops_zone" {
  provider     = aws.ops
  name         = "welltowercloud.com."
  private_zone = true
}