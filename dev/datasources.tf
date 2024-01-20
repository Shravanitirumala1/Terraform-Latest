data "aws_route53_zone" "ops_zone" {
  provider     = aws.ops
  name         = "welltowercloud.com."
  private_zone = true
}

data "aws_key_pair" "dev" {
  key_name           = "ST-dev-eks"
  include_public_key = true
  #filter {
  #  name   = "tag:Component"
  #  values = ["web"]
  #}
}