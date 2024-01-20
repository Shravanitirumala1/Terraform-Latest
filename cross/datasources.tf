data "aws_key_pair" "prod" {
  key_name           = "wl-prod-eks"
  include_public_key = true
  #filter {
  #  name   = "tag:Component"
  #  values = ["web"]
  #}
}

data "aws_route53_zone" "ops_zone" {
  provider     = aws.ops
  name         = "wellops4500.com."
  private_zone = true
}