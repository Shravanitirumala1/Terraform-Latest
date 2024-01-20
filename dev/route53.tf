#locals {
#   zone_name = sort(keys(module.zones.route53_zone_name))[0]
#   zone_id = module.zones.route53_zone_zone_id["dev.wellops4500.com"]
#}
##variable "ss_vpc_id" {
#  type        = string
#  default     = "vpc-0e4b0e2262335a5c0"
#} 
#module "zones" {
#  source = "../modules/route53/modules/zones"
#
#  zones = {
#    "dev.wellops4500.com" = {
#      domain_name = "dev.wellops4500.com"
#      comment     = "dev.wellops4500.com"
#      vpc = [
#        {
#          vpc_id = module.vpc.vpc
#          #vpc_id = var.ss_vpc_id #data.aws_vpc.vpc.id
#        },
#      ]
#      tags = {
#        Name = "dev.wellops4500.com"
#      }
#    }
#}
#
#  tags = {
#    ManagedBy = "Terraform"
#  }
#}

#module "elastic" {
#  source = "../modules/route53"
#  
# #aliases         = ["www.fasb-live.dev.faf.us.com."]
#  aliases         = ["ST-search-dev.wellops4500.com"]
#  parent_zone_id  = data.aws_route53_zone.ops_zone.zone_id #module.zones.route53_zone_zone_id["dev.faf.us.com"] #data.aws_route53_zone.zone.zone_id #module.zones.dev.zone_id
#  target_dns_name = module.es.dns_name
#  target_zone_id  = module.es.zone_id
#}