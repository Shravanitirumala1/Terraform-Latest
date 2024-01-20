data "aws_key_pair" "uat" {
  key_name           = "st-uat-eks"
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